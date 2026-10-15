# izel-skill

面向 Agent 的可执行产品管理 skills：先判断值不值得做，再按需打磨与调研，然后写产品规格和技术规格。

## Skills

| Skill | 用途 |
|-------|------|
| [`worth-it-or-not`](skills/worth-it-or-not/SKILL.md) | 先读项目事实，再判定值不值得做。首轮只出一道灵魂拷问；作答后再追问，最多 3 题 |
| [`product-design-philosophy`](skills/product-design-philosophy/SKILL.md) | 方向确定后，按产品价值主张打磨体验、文案、结构与路径 |
| [`product-research`](skills/product-research/SKILL.md) | 行业摸底与竞品分析，结论带来源 |
| [`product-spec`](skills/product-spec/SKILL.md) | 产品规格（业务层）：目标、角色与流程、故事、规则、边界与验收。不写接口与实现 |
| [`tech-spec`](skills/tech-spec/SKILL.md) | 技术规格：须已有产品规格。写架构、接口与数据契约、实现决策与测试决策 |
| [`team-git-workflow`](skills/team-git-workflow/SKILL.md) | 建分支、提交、推送、开 PR 或处理冲突前先预检，保护已有改动与共享历史 |

## 建议顺序

worth-it-or-not →（按需）product-design-philosophy / product-research → product-spec → tech-spec。

业务问题还不清楚时，先做 worth-it-or-not，不要直接写规格。tech-spec 只实现已有产品规格，不另立业务范围。

Git 操作用 team-git-workflow。它不插入上面的产品顺序。

## 安装

用 [skills CLI](https://github.com/vercel-labs/skills) 安装本仓库全部 skills。仓库布局是 `skills/<name>/SKILL.md`，CLI 会直接发现，无需额外安装包。

```bash
npx skills add Izelzzz/izel-skill
```

常用参数：

```bash
npx skills add Izelzzz/izel-skill -l
npx skills add Izelzzz/izel-skill --skill worth-it-or-not
npx skills add Izelzzz/izel-skill -a cursor -y
```

`-l` 只列出不安装，`--skill` 只装一个，`-a` 指定 agent，`-y` 跳过确认。

CLI 不可用时，可以手动复制：

```bash
cp -R skills/* ~/.claude/skills/
cp -R skills/* ./.agents/skills/
```

## 文档落盘

完整的产品规格与技术规格默认写进当前仓库的 [`docs/`](docs/README.md)。文件名例如 `docs/<短标题>-产品规格.md`、`docs/<短标题>-技术规格.md`。用户指定了路径时用该路径。没有可写仓库时，改为在对话中给出全文，并说明未能落盘。

## 评测

[`evals/evals.json`](evals/evals.json) 覆盖本套件：worth-it-or-not、product-design-philosophy、product-spec、tech-spec、team-git-workflow，以及 product-research。提示为中文用户口吻，assertions 对照各 skill 的对外契约。可按 skill-creator 流程跑 benchmark。

## License

MIT © 2026 Izelzzz
