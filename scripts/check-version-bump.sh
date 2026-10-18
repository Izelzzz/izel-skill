#!/usr/bin/env bash
# 技能目录有改动时，要求同一变更里的 VERSION 与基线不同，CHANGELOG.md 有改动，
# 并且 CHANGELOG.md 含有与新版本对应的 Keep a Changelog 标题（## [X.Y.Z]）。
# 用法: scripts/check-version-bump.sh [base_sha] [head_sha]
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

BASE="${1:-${BASE_SHA:-}}"
HEAD="${2:-${HEAD_SHA:-HEAD}}"

fail() {
  printf '%s\n' "$@" >&2
  if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    {
      echo "### 版本检查未通过"
      echo
      printf '%s\n' "$@"
      echo
    } >>"$GITHUB_STEP_SUMMARY"
  fi
  exit 1
}

ok() {
  echo "$*"
  if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    echo "$*" >>"$GITHUB_STEP_SUMMARY"
  fi
}

resolve_commit() {
  git rev-parse --verify "${1}^{commit}" 2>/dev/null
}

read_version() {
  local sha="$1"
  if ! git cat-file -e "${sha}:VERSION" 2>/dev/null; then
    printf ''
    return
  fi
  git show "${sha}:VERSION" | tr -d '[:space:]'
}

changelog_has_version_section() {
  local sha="$1"
  local version="$2"
  local escaped
  escaped=$(printf '%s' "$version" | sed 's/[.[\*^$()|+?{}]/\\&/g')
  git show "${sha}:CHANGELOG.md" | grep -E -q "^## \\[${escaped}\\]([[:space:]]|$)"
}

collect_prefixes() {
  local sha="$1"
  git ls-tree -r --name-only "$sha" | awk '
    {
      path = $0
      if (path == "SKILL.md") {
        print "."
      } else if (path ~ /(^|\/)SKILL\.md$/) {
        if (path ~ /^skills\//) {
          print "skills"
        } else {
          sub(/\/SKILL\.md$/, "", path)
          print path
        }
      }
    }
  '
  if git cat-file -e "${sha}:skills" 2>/dev/null; then
    echo skills
  fi
}

SEMVER='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'

HEAD_COMMIT=$(resolve_commit "$HEAD") || fail "无法解析要检查的提交：${HEAD}"

head_version=$(read_version "$HEAD_COMMIT")
if [[ -z "$head_version" ]]; then
  fail "根目录需要 VERSION 文件，内容为语义化版本 X.Y.Z。"
fi
if [[ ! "$head_version" =~ $SEMVER ]]; then
  fail "VERSION（${head_version}）需要是语义化版本 X.Y.Z。"
fi
if ! git cat-file -e "${HEAD_COMMIT}:CHANGELOG.md" 2>/dev/null; then
  fail "根目录需要 CHANGELOG.md，并在其中记录 ${head_version}。"
fi
if git cat-file -e "${HEAD_COMMIT}:README.md" 2>/dev/null; then
  readme=$(git show "${HEAD_COMMIT}:README.md")
  escaped_version=$(printf '%s' "$head_version" | sed 's/[.[\*^$()|+?{}]/\\&/g')
  if ! printf '%s\n' "$readme" | grep -Eq "(^|[^0-9.])${escaped_version}([^0-9.]|$)"; then
    fail "README.md 的版本节需要写上当前 VERSION（${head_version}）。"
  fi
fi

if [[ -z "$BASE" || "$BASE" =~ ^0+$ ]]; then
  ok "没有可比较的基线提交。已确认 VERSION=${head_version}。"
  exit 0
fi

BASE_COMMIT=$(resolve_commit "$BASE") || fail "无法解析基线提交：${BASE}"

prefixes=()
while IFS= read -r prefix; do
  [[ -n "$prefix" ]] || continue
  prefixes+=("$prefix")
done < <(
  {
    collect_prefixes "$BASE_COMMIT"
    collect_prefixes "$HEAD_COMMIT"
  } | awk 'NF && !seen[$0]++'
)

if [[ ${#prefixes[@]} -eq 0 ]]; then
  ok "未发现技能目录。VERSION=${head_version}。"
  exit 0
fi

if from=$(git merge-base "$BASE_COMMIT" "$HEAD_COMMIT" 2>/dev/null); then
  :
else
  from="$BASE_COMMIT"
fi

skill_changes=()
while IFS= read -r path; do
  [[ -n "$path" ]] || continue
  skill_changes+=("$path")
done < <(git diff --name-only "$from" "$HEAD_COMMIT" -- "${prefixes[@]}")

if [[ ${#skill_changes[@]} -eq 0 ]]; then
  ok "技能目录无改动。VERSION=${head_version}。"
  exit 0
fi

echo "技能目录有改动："
printf '  %s\n' "${skill_changes[@]}"

base_version=$(read_version "$BASE_COMMIT")
changelog_changed=0
if [[ -n "$(git diff --name-only "$from" "$HEAD_COMMIT" -- CHANGELOG.md)" ]]; then
  changelog_changed=1
fi

changed_list=$(printf '%s ' "${skill_changes[@]}")

if [[ "$base_version" == "$head_version" ]]; then
  fail "skill 变更时请 bump VERSION 并更新 CHANGELOG。" "VERSION 仍为 ${head_version}，与基线相同。请改为新的 X.Y.Z，并更新 CHANGELOG.md。变更文件：${changed_list}"
fi

if [[ "$changelog_changed" -eq 0 ]]; then
  fail "skill 变更时请 bump VERSION 并更新 CHANGELOG。" "VERSION 已从 ${base_version:-（无）} 改为 ${head_version}。请同时更新 CHANGELOG.md。变更文件：${changed_list}"
fi

if ! changelog_has_version_section "$HEAD_COMMIT" "$head_version"; then
  fail "skill 变更时请 bump VERSION 并更新 CHANGELOG。" "VERSION 已改为 ${head_version}，但 CHANGELOG.md 没有对应小节。请加上标题 ## [${head_version}]。"
fi

ok "技能目录有改动，VERSION ${base_version:-（无）} → ${head_version}，CHANGELOG.md 含 ## [${head_version}]。"
