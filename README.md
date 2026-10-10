# pm-skill

面向 Agent 的可执行产品管理 Skills。  
Executable product-management skills for AI agents.

把产品设计原则、哲学、调研与方案规范写成可逐步执行的 playbook。

## Skills

| Skill | 何时使用 |
|-------|----------|
| [`product-design-principles`](skills/product-design-principles/SKILL.md) | 提出、评审或批准方案前，检查问题、复杂度、业务模型和投入回报 |
| [`product-design-philosophy`](skills/product-design-philosophy/SKILL.md) | 按场景选择四项设计哲学，评分并输出改动 |
| [`product-research`](skills/product-research/SKILL.md) | 用来源记录、竞品记录和证据链完成产品调研 |
| [`product-spec`](skills/product-spec/SKILL.md) | 编写或评审 PRD，检查流程、边界和可测验收标准 |

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

1. `product-design-principles` — 检查产品问题、复杂度、业务模型和投入回报
2. `product-design-philosophy` — 按场景打磨体验和表达
3. `product-research` — 需要外部证据时执行调研
4. `product-spec` — 输出可评审、可验收的产品方案

## 写法参考

格式与结构参考（非抄袭内容）：

- [obra/superpowers](https://github.com/obra/superpowers)
- [mattpocock/skills](https://github.com/mattpocock/skills)

正文文风受 ASD-STE100 启发：短句、主动语态、MUST/SHOULD 规则。

## License

MIT © 2026 Izelzzz
