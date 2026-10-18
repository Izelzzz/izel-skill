#!/usr/bin/env bash
# 把仓库版本写成新的 X.Y.Z，并在 CHANGELOG.md 插入一节。
# 用法: scripts/bump-version.sh <X.Y.Z> <变更说明>
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "用法: scripts/bump-version.sh <X.Y.Z> <变更说明>" >&2
  exit 2
fi

version="$1"
shift
note="$*"
semver='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'

if [[ ! "$version" =~ $semver ]]; then
  echo "版本号需要是 X.Y.Z，收到：${version}" >&2
  exit 1
fi

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

if [[ ! -f CHANGELOG.md ]]; then
  echo "找不到 CHANGELOG.md" >&2
  exit 1
fi

escaped=$(printf '%s' "$version" | sed 's/[.[\*^$]/\\&/g')
if grep -E -q "^## \\[${escaped}\\]([[:space:]]|$)" CHANGELOG.md; then
  echo "CHANGELOG.md 已有 [${version}]。请直接编辑该节。" >&2
  exit 1
fi

printf '%s\n' "$version" >VERSION

# GNU sed 接受 sed -i；BSD sed（macOS）要求备份后缀。-i.bak 两边都能用。
sed_inplace() {
  local file="$1"
  shift
  sed -i.bak "$@" "$file"
  rm -f "${file}.bak"
}

if [[ -f README.md ]] && grep -q '当前版本是 \*\*' README.md; then
  sed_inplace README.md -E "s/当前版本是 \\*\\*[0-9]+\\.[0-9]+\\.[0-9]+\\*\\*/当前版本是 **${version}**/"
fi

today=$(date -u +%Y-%m-%d)
section_file=$(mktemp)
trap 'rm -f "$section_file"' EXIT
cat >"$section_file" <<EOF
## [${version}] - ${today}

### 新增

- ${note}

EOF

tmp=$(mktemp)
awk '
  !inserted && /^## \[[0-9]/ {
    while ((getline line < secfile) > 0) print line
    close(secfile)
    inserted = 1
  }
  { print }
  END {
    if (!inserted) {
      print ""
      while ((getline line < secfile) > 0) print line
      close(secfile)
    }
  }
' secfile="$section_file" CHANGELOG.md >"$tmp"
mv "$tmp" CHANGELOG.md

echo "VERSION=${version}"
echo "已在 CHANGELOG.md 写入 [${version}]。"
