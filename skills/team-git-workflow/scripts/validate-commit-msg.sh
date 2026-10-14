#!/usr/bin/env bash
# 拒绝空提交说明，以及整句只有 update / fix 的空洞说明。
# 用法:
#   validate-commit-msg.sh <消息文件>
#   validate-commit-msg.sh -m "说明"
#   printf '%s\n' "说明" | validate-commit-msg.sh
# 退出码: 0 通过机械检查；1 拒绝。
# 说明是否写明改了什么，以 references/commit-rules.md 为准。脚本通过不等于说明合格。
set -euo pipefail

usage() {
  cat <<'EOF'
用法:
  validate-commit-msg.sh <消息文件>
  validate-commit-msg.sh -m "说明"
  printf '%s\n' "说明" | validate-commit-msg.sh

退出码: 0 通过机械检查；1 拒绝。
本脚本拒绝空说明，以及整句只有 update / fix 的说明。
说明是否写明改了什么，以 references/commit-rules.md 为准。
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

message=""
if [[ $# -eq 0 ]]; then
  if [[ -t 0 ]]; then
    usage >&2
    exit 1
  fi
  message="$(cat)"
elif [[ "$1" == "-m" ]]; then
  if [[ $# -ne 2 ]]; then
    echo "validate-commit-msg: -m 之后需要一段说明。" >&2
    exit 1
  fi
  message="$2"
elif [[ $# -eq 1 ]]; then
  if [[ ! -f "$1" ]]; then
    echo "validate-commit-msg: 找不到文件: $1" >&2
    exit 1
  fi
  message="$(cat -- "$1")"
else
  usage >&2
  exit 1
fi

subject=""
while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ "$line" =~ ^[[:space:]]*# ]]; then
    continue
  fi
  if [[ -z "${line//[[:space:]]/}" ]]; then
    continue
  fi
  subject="$line"
  break
done <<< "$message"

COMMIT_SUBJECT="$subject" python3 - <<'PY'
import os
import re
import sys

subject = os.environ.get("COMMIT_SUBJECT", "").strip()
match = re.match(
    r"(?i)^(feat|fix|chore|docs|refactor|test|style|perf|build|ci|revert)"
    r"(\([A-Za-z0-9._/-]+\))?(!)?:\s*(.*)$",
    subject,
)
if match:
    subject = match.group(4).strip()
subject = re.sub(r"[.\!。！]+\s*$", "", subject).strip()
norm = re.sub(r"\s+", " ", subject).strip().lower()

if not norm:
    print("validate-commit-msg: 提交说明为空。主题行要写明改了什么。", file=sys.stderr)
    sys.exit(1)

phrases = {
    "update",
    "updates",
    "updated",
    "updating",
    "fix",
    "fixed",
    "fixes",
    "fixing",
    "fixup",
    "fix update",
    "update fix",
    "minor fix",
    "small fix",
    "quick fix",
    "bug fix",
    "fix bug",
    "fix bugs",
    "fix code",
    "fix issue",
    "fix issues",
    "fix typo",
    "typo fix",
    "various fixes",
    "update code",
    "update files",
    "update docs",
    "update readme",
    "minor update",
    "small update",
    "quick update",
    "minor changes",
    "small changes",
}
if norm in phrases:
    print(
        "validate-commit-msg: 主题行只有 update / fix 一类空洞字样。写明改动的对象和变更。",
        file=sys.stderr,
    )
    sys.exit(1)

hollow_words = {
    "update",
    "updates",
    "updated",
    "updating",
    "fix",
    "fixed",
    "fixes",
    "fixing",
    "fixup",
    "minor",
    "small",
    "quick",
    "bug",
    "bugs",
    "code",
    "files",
    "docs",
    "readme",
    "stuff",
    "typo",
    "various",
    "issue",
    "issues",
    "changes",
    "change",
}
stopwords = {"a", "an", "the", "of", "to", "for", "and", "or", "in", "on"}
words = re.findall(r"[a-z0-9]+(?:-[a-z0-9]+)*", norm)
content_words = [word for word in words if word not in stopwords]
has_cjk = re.search(r"[\u4e00-\u9fff]", subject) is not None
if content_words and all(word in hollow_words for word in content_words) and not has_cjk:
    print(
        "validate-commit-msg: 主题行只有 update / fix 一类空洞字样。写明改动的对象和变更。",
        file=sys.stderr,
    )
    sys.exit(1)

sys.exit(0)
PY
