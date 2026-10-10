# pm-skill

面向 Agent 的可执行产品管理 skills。  
Executable product-management skills for AI agents.

本仓库将产品设计原则、设计哲学、调研与方案规范写成可执行流程，供 Agent 按步骤判断与交付。

## Skills

| Skill | 用途 |
|-------|------|
| [`product-design-principles`](skills/product-design-principles/SKILL.md) | 提出或批准方案前的四项准则审查 |
| [`product-design-philosophy`](skills/product-design-philosophy/SKILL.md) | 方向确定后的体验与表达审查 |
| [`product-research`](skills/product-research/SKILL.md) | 行业摸底与竞品分析 |
| [`product-spec`](skills/product-spec/SKILL.md) | 可开发、可验收的产品方案（PRD） |

建议顺序：原则 →（按需）哲学 →（按需）调研 → 规格。

## 安装

将 `skills/` 下各目录复制到 Agent skills 路径，例如：

```bash
cp -R skills/* ~/.claude/skills/
cp -R skills/* ./.agents/skills/
```

每个 skill 为一个文件夹，内含 `SKILL.md`。

## 文风

写法参考 [obra/superpowers](https://github.com/obra/superpowers)、[mattpocock/skills](https://github.com/mattpocock/skills)。  
表述受 ASD-STE100 启发：句子短、语态主动、用词稳定；结构收紧，避免碎段落与模糊的优先级或评分标准。

## License

MIT © 2026 Izelzzz
