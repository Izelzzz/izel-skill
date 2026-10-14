#!/usr/bin/env bash
# 检查分支名是否符合 team-git-workflow 的命名规则。
# 名字合法不表示允许新建侧分支。是否创建侧分支见 references/branch-rules.md。
# 用法: validate-branch.sh [分支名]
# 省略分支名时检查当前分支。
# 退出码: 0 合法；1 不合法或无法确定；2 受保护主干（main / master）。
set -euo pipefail

usage() {
  cat <<'EOF'
用法: validate-branch.sh [分支名]

省略分支名时检查当前分支。
退出码:
  0  名称可作为工作分支或侧分支
  1  命名不合法，或无法确定当前分支
  2  main 或 master（受保护主干，不是工作分支名）
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
    echo "validate-branch: 无法读取当前分支。请传入分支名，或在 Git 仓库中运行。" >&2
    exit 1
  fi
else
  name="$1"
fi

name="${name#refs/heads/}"

if [[ -z "$name" || "$name" == "HEAD" ]]; then
  echo "validate-branch: 空名称或游离 HEAD 不是合法分支名。" >&2
  exit 1
fi

if [[ "$name" == "main" || "$name" == "master" ]]; then
  echo "validate-branch: ${name} 是受保护主干。用户未点名时不得作为工作分支，也不得直推。" >&2
  exit 2
fi

if [[ "$name" == cursor/* ]]; then
  echo "validate-branch: 禁止 cursor/ 前缀。侧分支用完即删，不得作为本仓库的分支名。" >&2
  exit 1
fi

pattern='^(feature|fix|chore|docs|refactor|test)/[a-z0-9]+(-[a-z0-9]+)*(/[a-z0-9]+(-[a-z0-9]+)*)?$'
if [[ ! "$name" =~ $pattern ]]; then
  echo "validate-branch: 「${name}」不符合命名。使用 feature/global，或 <类型>/<简述>（类型为 feature、fix、chore、docs、refactor、test；简述仅含小写字母、数字与连字符）。" >&2
  exit 1
fi

exit 0
