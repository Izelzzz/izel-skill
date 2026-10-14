#!/usr/bin/env bash
# Check a branch name against the default task-branch pattern <type>/<desc>.
# 检查分支名是否符合默认任务分支格式 <type>/<desc>。
# Repo-defined names (protected bases, izel-skill's feature/global) are a
# policy decision in SKILL.md, not a pass/fail of this script.
# 仓库规定的分支名（受保护基线、izel-skill 的 feature/global）由 SKILL.md 决定，
# 脚本返回 1 只表示它不符合默认格式。
# Usage: validate-branch.sh [branch-name]
# Exit: 0 match; 1 mismatch, empty, detached, or unreadable.
set -euo pipefail

usage() {
  cat <<'EOF'
用法 / usage: validate-branch.sh [分支名]

省略分支名时检查当前分支。
Omit the name to check the current branch.

退出码 / exit:
  0  符合默认格式 <type>/<desc>
  1  不符合，或无法确定当前分支

type: feat, fix, refactor, docs, test, chore, hotfix
desc: lowercase letters, digits, hyphens
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 1
fi

if [[ $# -eq 0 ]]; then
  if ! name="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"; then
    echo "validate-branch: 无法读取当前分支。请传入分支名，或在 Git 仓库中运行。 (cannot read current branch)" >&2
    exit 1
  fi
else
  name="$1"
fi

name="${name#refs/heads/}"

if [[ -z "$name" || "$name" == "HEAD" ]]; then
  echo "validate-branch: 空名称或游离 HEAD 不符合默认任务分支格式。 (empty or detached HEAD)" >&2
  exit 1
fi

pattern='^(feat|fix|refactor|docs|test|chore|hotfix)/[a-z0-9]+(-[a-z0-9]+)*$'
if [[ ! "$name" =~ $pattern ]]; then
  echo "validate-branch: 「${name}」不符合 <type>/<desc>。类型为 feat、fix、refactor、docs、test、chore、hotfix；描述仅含小写字母、数字和连字符。仓库已规定的分支名不受本脚本约束。 (does not match default pattern)" >&2
  exit 1
fi

exit 0
