# pm-skill

面向 Agent 的可执行产品管理 skills。  
Executable product-management skills for AI agents.

教 agent **怎么想、怎么做、做到什么算完**——不是长文笔记，也不是填空表格。

## Skills

| Skill | 何时用 |
|-------|--------|
| [`product-design-principles`](skills/product-design-principles/SKILL.md) | 提出/批准方案前，过四道闸门，有缺口就别说可上线 |
| [`product-design-philosophy`](skills/product-design-philosophy/SKILL.md) | 方向已定，按场景打磨体验与表达 |
| [`product-research`](skills/product-research/SKILL.md) | 行业摸底与竞品分析，直到趋势/机会/差异化有出处 |
| [`product-spec`](skills/product-spec/SKILL.md) | 写或审 PRD：九段活文档 + 可测验收 |

## Install

把 `skills/` 下各目录拷到你的 Agent skills 路径，例如：

```bash
cp -R skills/* ~/.claude/skills/
# 或项目内
cp -R skills/* ./.agents/skills/
```

每个 skill 是一个文件夹，内含 `SKILL.md`。具体路径以你的 Agent 文档为准。

## Suggested order

1. `product-design-principles` — 该不该做  
2. `product-design-philosophy` — 做成什么样（按需）  
3. `product-research` — 需要市场证据时  
4. `product-spec` — 可开发、可验收的规格  

## Style

写法参考 [obra/superpowers](https://github.com/obra/superpowers)、[mattpocock/skills](https://github.com/mattpocock/skills)。  
文风受 ASD-STE100 启发：短句、主动语态、一词一义。

## License

MIT © 2026 Izelzzz
