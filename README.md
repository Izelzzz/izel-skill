# izel-skill

面向 Agent 的可执行产品管理 skills。  
Executable product-management skills for AI agents.

本仓库将「值不值得做」审查、设计哲学、调研、产品规格与技术规格写成可执行流程，供 Agent 按步骤判断与交付。写法遵循 Anthropic skill-creator 惯例：description 承担触发与「何时用」，正文用祈使句给出可跟步骤与固定输出骨架。

## Skills

| Skill | 用途 |
|-------|------|
| [`worth-it-or-not`](skills/worth-it-or-not/SKILL.md) | 先读项目事实，再判定值不值得做；缺口用 ≤3 题追问补齐 |
| [`product-design-philosophy`](skills/product-design-philosophy/SKILL.md) | 方向确定后打磨体验与文案；对外给可执行修改 |
| [`product-research`](skills/product-research/SKILL.md) | 行业摸底与竞品分析 |
| [`product-spec`](skills/product-spec/SKILL.md) | 产品规格文档（业务层）：目标、结构与流程、故事、规则与验收 |
| [`tech-spec`](skills/tech-spec/SKILL.md) | 技术规格文档：须基于产品规格，写架构、接口契约、实现决策与测试决策 |
| [`team-git-workflow`](skills/team-git-workflow/SKILL.md) | 创建分支、提交、推送、开 PR、处理冲突或直推前，先预检并保护用户改动与共享历史 |

建议顺序：worth-it-or-not →（按需）哲学 →（按需）调研 → product-spec → tech-spec。触碰 Git 时使用 team-git-workflow，它不插入这条产品顺序。

## 安装

将 `skills/` 下各目录复制到 Agent skills 路径，例如：

```bash
cp -R skills/* ~/.claude/skills/
cp -R skills/* ./.agents/skills/
```

每个 skill 为一个文件夹，内含 `SKILL.md`。

## 评测

`evals/evals.json` 提供一套面向四 skill 的真实用户口吻提示，用于触发与产出对照。可按 skill-creator 流程补 assertions 并跑 benchmark。

## 文风

写法参考 [obra/superpowers](https://github.com/obra/superpowers)、[mattpocock/skills](https://github.com/mattpocock/skills)，并遵循 Anthropic skill-creator 写作指南：触发信息放在 description、正文祈使句、解释 why、固定输出模板、短例。  
表述受 ASD-STE100 启发：句子短、语态主动、用词稳定；结构收紧，避免碎段落与模糊的优先级或评分标准。

## License

MIT © 2026 Izelzzz
