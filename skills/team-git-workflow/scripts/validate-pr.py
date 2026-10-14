#!/usr/bin/env python3
"""检查 PR 标题与正文必填段。

用法:
  validate-pr.py --title "标题" --body-file body.md
  validate-pr.py --title-file title.txt --body-file body.md
  validate-pr.py --title "标题" --body "## 改了什么\\n..."

标题与 validate-commit-msg.sh 使用同一套空洞说明检查。
正文必须包含三段二级标题，且各段有内容。见 references/pr-rules.md。
脚本未接入 CI 时，Agent 仍要按该模板写 PR。直推任务不要创建 PR。
退出码: 0 通过；1 有缺项。
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

GROUPS: tuple[tuple[str, tuple[str, ...]], ...] = (
    ("改了什么", ("改了什么", "what changed", "summary")),
    ("如何验证", ("如何验证", "how to verify", "test plan")),
    ("链接", ("链接", "links", "references")),
)

PLACEHOLDERS = {
    "todo",
    "tbd",
    "...",
    "…",
    "n/a",
    "na",
    "待定",
    "待补充",
    "无内容",
    "xxx",
    "fixme",
    "更新代码",
    "测试一下",
}

LINK_EXPLICIT_EMPTY = {"无", "none", "无相关链接", "n/a", "暂无"}


def read_text(value: str | None, file_path: str | None, label: str, flags: str) -> str:
    if value is not None and file_path is not None:
        raise SystemExit(f"validate-pr: {label}只能从一处提供（{flags}）。")
    if file_path is not None:
        path = Path(file_path)
        if not path.is_file():
            raise SystemExit(f"validate-pr: 找不到{label}文件: {file_path}")
        return path.read_text(encoding="utf-8")
    if value is not None:
        return value
    raise SystemExit(f"validate-pr: 缺少{label}。使用 {flags}。")


def title_errors(title: str) -> list[str]:
    script = Path(__file__).resolve().parent / "validate-commit-msg.sh"
    if not script.is_file():
        return ["validate-pr: 找不到 validate-commit-msg.sh，无法检查标题。"]
    completed = subprocess.run(
        [str(script), "-m", title],
        check=False,
        capture_output=True,
        text=True,
    )
    if completed.returncode == 0:
        return []
    detail = (completed.stderr or completed.stdout).strip()
    detail = detail.removeprefix("validate-commit-msg:").strip()
    if not detail:
        detail = "标题未通过空洞说明检查。"
    return [f"validate-pr: 标题不合格。{detail}"]


def normalize_heading(text: str) -> str:
    heading = text.strip().lower()
    heading = re.sub(r"\s*[（(][^）)]*[）)]\s*$", "", heading)
    return re.sub(r"\s+", " ", heading).strip()


def parse_sections(body: str) -> dict[str, str]:
    found: dict[str, list[str]] = {name: [] for name, _aliases in GROUPS}
    current: str | None = None
    for line in body.splitlines():
        match = re.match(r"^##\s+(.+?)\s*$", line)
        if match:
            normalized = normalize_heading(match.group(1))
            current = None
            for name, aliases in GROUPS:
                if normalized in aliases:
                    current = name
                    break
            continue
        if current is not None:
            found[current].append(line)
    return {name: "\n".join(lines).strip() for name, lines in found.items()}


def section_errors(sections: dict[str, str]) -> list[str]:
    errors: list[str] = []
    for name, _aliases in GROUPS:
        content = sections.get(name, "").strip()
        if not content:
            errors.append(f"validate-pr: 正文缺少「{name}」，或该段为空。")
            continue
        flattened = re.sub(r"\s+", " ", content).strip()
        flattened = re.sub(r"^[-*]\s*", "", flattened)
        token = flattened.lower().strip(" .。")
        if name == "链接" and token in LINK_EXPLICIT_EMPTY:
            continue
        if token in PLACEHOLDERS or token in {"update", "fix", "fixed", "fixes"}:
            errors.append(f"validate-pr: 「{name}」只有占位或空洞字样。写入该段要求的内容。")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="检查 PR 标题与正文必填段")
    parser.add_argument("--title", help="PR 标题")
    parser.add_argument("--title-file", help="含有 PR 标题的文件")
    parser.add_argument("--body", help="PR 正文")
    parser.add_argument("--body-file", help="含有 PR 正文的文件")
    args = parser.parse_args()

    try:
        title = read_text(args.title, args.title_file, "标题", "--title 或 --title-file")
        body = read_text(args.body, args.body_file, "正文", "--body 或 --body-file")
    except SystemExit as exc:
        if exc.code not in (0, None):
            print(exc.code if isinstance(exc.code, str) else "validate-pr: 参数不完整。", file=sys.stderr)
            return 1
        raise

    errors = title_errors(title.strip())
    errors.extend(section_errors(parse_sections(body)))
    if errors:
        for error in errors:
            print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
