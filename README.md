# pm-skill

面向 Agent 的可执行产品管理 Skills。  
Executable product-management skills for AI agents.

把产品设计原则、哲学、调研与方案规范写成可逐步执行的 playbook，而不是长文笔记。

## Skills

| Skill | 何时使用 |
|-------|----------|
| [`product-design-principles`](skills/product-design-principles/SKILL.md) | 提出或批准方案前，强制跑四原则检查 |
| [`product-design-philosophy`](skills/product-design-philosophy/SKILL.md) | 按场景选用少即是多 / 长期主义 / 控预期 / 叙事，并打分 |
| [`product-research`](skills/product-research/SKILL.md) | 行业报告、技术文档、竞品分析，直到趋势/机会/差异化齐备 |
| [`product-spec`](skills/product-spec/SKILL.md) | 写或审 PRD/产品方案，九段模板 + 可测验收闸门 |

## 安装 / Install

将 `skills/` 下各目录复制到你的 Agent skills 路径，例如：

```bash
# Claude Code / 兼容 Agent Skills 目录的工具
cp -R skills/* ~/.claude/skills/
# 或项目内
cp -R skills/* ./.agents/skills/
```

具体路径以你使用的 Agent 产品文档为准。每个 skill 是一个文件夹，内含 `SKILL.md`。

## 使用建议

推荐顺序：

1. `product-design-principles` — 先过硬原则  
2. `product-design-philosophy` — 按场景打磨（可选）  
3. `product-research` — 需要市场证据时  
4. `product-spec` — 输出可开发、可验收的规格  

## 写法参考

格式与结构参考（非抄袭内容）：

- [obra/superpowers](https://github.com/obra/superpowers)
- [mattpocock/skills](https://github.com/mattpocock/skills)

正文文风受 ASD-STE100 启发：短句、主动语态、MUST/SHOULD 规则。

## License

MIT © 2026 Izelzzz
