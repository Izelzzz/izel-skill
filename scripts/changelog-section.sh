#!/usr/bin/env bash
# 打印 CHANGELOG.md 里某个版本的小节，供发布说明使用。
# 用法: scripts/changelog-section.sh <X.Y.Z> [CHANGELOG.md]
set -euo pipefail

version="${1:-}"
file="${2:-CHANGELOG.md}"

if [[ -z "$version" ]]; then
  echo "用法: scripts/changelog-section.sh <X.Y.Z> [CHANGELOG.md]" >&2
  exit 2
fi

if [[ ! -f "$file" ]]; then
  echo "找不到 ${file}" >&2
  exit 1
fi

section=$(awk -v ver="$version" '
  BEGIN {
    gsub(/\./, "\\.", ver)
    header = "^## \\[" ver "\\]([ \\t]|$)"
  }
  $0 ~ header { found = 1 }
  found && /^## \[/ && $0 !~ header { exit }
  found && /^\[[^]]+\]: / { exit }
  found { print }
' "$file")

if [[ -z "$section" ]]; then
  echo "CHANGELOG.md 中没有版本 [${version}] 的小节。请写下该版本的变更后再打标签。" >&2
  exit 1
fi

printf '%s\n' "$section"
