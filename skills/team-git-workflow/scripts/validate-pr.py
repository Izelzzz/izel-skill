#!/usr/bin/env python3
"""Validate a pull request title and the default body sections.

校验 PR 标题，以及默认正文的必填节。

Usage:
  validate-pr.py --title "fix: refresh tokens" --body-file body.md
  validate-pr.py --title-file title.txt --body-file body.md
  validate-pr.py --title "feat: add summary" --body "## 摘要\\n..."

Required sections / 必填: 摘要 Summary, 变更 Changes, 验证 Validation.
验证节也接受「应测」和「Test plan」。这一节应写评审应测的清单。
脚本不要求、也不检查「未测」或「跑过」。
Optional sections are omitted when they do not apply. If present, they need
real content. 可选节（风险与说明、相关问题）不适用时省略；写了就不能是占位符。

Exit: 0 accepted; 1 rejected.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

REQUIRED: tuple[tuple[str, tuple[str, ...]], ...] = (
    ("摘要", ("摘要", "summary")),
    ("变更", ("变更", "changes")),
    ("验证", ("验证", "应测", "validation", "test plan", "验证 / test plan", "验证 / validation", "应测 / test plan")),
)
OPTIONAL: tuple[tuple[str, tuple[str, ...]], ...] = (
    ("风险与说明", ("风险与说明", "risks and notes", "risks")),
    ("相关问题", ("相关问题", "related issues")),
)
GROUPS = REQUIRED + OPTIONAL

PLACEHOLDERS = {
    "todo",
    "tbd",
    "...",
    "…",
    "n/a",
    "na",
    "none",
    "无",
    "无内容",
    "暂无",
    "待定",
    "待补充",
    "xxx",
    "fixme",
    "update",
    "fix",
    "changes",
    "更新",
    "修复",
    "改动",
}


def read_text(value: str | None, file_path: str | None, label: str, flags: str) -> str:
    if value is not None and file_path is not None:
        raise SystemExit(
            f"validate-pr: {label}只能从一个来源提供（{flags}）。 (provide {label} once)"
        )
    if file_path is not None:
        path = Path(file_path)
        if not path.is_file():
            raise SystemExit(f"validate-pr: 找不到{label}文件: {file_path} (file not found)")
        return path.read_text(encoding="utf-8")
    if value is not None:
        return value
    raise SystemExit(f"validate-pr: 缺少{label}。使用 {flags}。 (missing {label})")


def title_errors(title: str) -> list[str]:
    script = Path(__file__).resolve().parent / "validate-commit-msg.sh"
    if not script.is_file():
        return ["validate-pr: 找不到 validate-commit-msg.sh，无法检查标题。 (missing commit checker)"]
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
        detail = "标题未通过默认格式检查。 (title rejected)"
    return [f"validate-pr: 标题不合格。{detail}"]


def normalize_heading(text: str) -> str:
    heading = text.strip().lower()
    heading = re.sub(r"\s*[（(][^）)]*[）)]\s*$", "", heading)
    return re.sub(r"\s+", " ", heading).strip()


def parse_sections(body: str) -> tuple[dict[str, str], list[str]]:
    found: dict[str, list[str]] = {name: [] for name, _aliases in GROUPS}
    seen: dict[str, int] = {name: 0 for name, _aliases in GROUPS}
    errors: list[str] = []
    current: str | None = None
    for line in body.splitlines():
        match = re.match(r"^##\s+(.+?)\s*$", line)
        if match:
            normalized = normalize_heading(match.group(1))
            current = None
            for name, aliases in GROUPS:
                if normalized in aliases:
                    seen[name] += 1
                    if seen[name] > 1:
                        errors.append(
                            f"validate-pr: 「{name}」重复。保留一节。 (duplicate section)"
                        )
                    current = name
                    break
            continue
        if current is not None:
            found[current].append(line)
    sections = {name: "\n".join(lines).strip() for name, lines in found.items()}
    return sections, errors


def is_placeholder(content: str) -> bool:
    flattened = re.sub(r"\s+", " ", content).strip()
    flattened = re.sub(r"^[-*]\s*", "", flattened)
    token = flattened.lower().strip(" .。")
    return token in PLACEHOLDERS


def section_errors(sections: dict[str, str]) -> list[str]:
    errors: list[str] = []
    for name, _aliases in REQUIRED:
        content = sections.get(name, "").strip()
        if not content or is_placeholder(content):
            errors.append(
                f"validate-pr: 正文缺少「{name}」，或该节只有占位内容。"
                " (missing or placeholder required section)"
            )
    for name, _aliases in OPTIONAL:
        content = sections.get(name, "").strip()
        if not content:
            continue
        if is_placeholder(content):
            errors.append(
                f"validate-pr: 「{name}」只有占位内容。没有实质内容时省略该节，不要写 N/A。"
                " (omit empty optional section)"
            )
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(
        description="检查 PR 标题与默认正文必填节。验证节可用「应测」或 Test plan；不要求正文出现「未测」或「跑过」。"
    )
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
            message = exc.code if isinstance(exc.code, str) else "validate-pr: 参数不完整。 (incomplete arguments)"
            print(message, file=sys.stderr)
            return 1
        raise

    errors = title_errors(title.strip())
    sections, parse_errors = parse_sections(body)
    errors.extend(parse_errors)
    errors.extend(section_errors(sections))
    if errors:
        for error in errors:
            print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
