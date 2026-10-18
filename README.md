# izel-skill

面向 Agent 的可执行产品管理 skills：先判断值不值得做，再按需打磨与调研，然后写产品规格和技术规格。

## Skills

| Skill | 用途 |
|-------|------|
| [`skill-dispatch`](skills/skill-dispatch/SKILL.md) | 入口路由。思路混乱、意图不清，或一次包含多步产品管理请求时，选定下一步该读的 skill，再交出去执行 |
| [`structured-thinking`](skills/structured-thinking/SKILL.md) | 把零散想法和模糊问题整理成清晰的问题定义、判断和可验证的行动 |
| [`worth-it-or-not`](skills/worth-it-or-not/SKILL.md) | 先读项目事实，再判定值不值得做。首轮只出一道灵魂拷问；作答后先消化，再按需追问。判断闭合后才进入下游 skill |
| [`product-design-philosophy`](skills/product-design-philosophy/SKILL.md) | 方向确定后，按产品价值主张打磨体验、文案、结构与路径 |
| [`product-research`](skills/product-research/SKILL.md) | 行业摸底与竞品分析，结论带来源 |
| [`product-spec`](skills/product-spec/SKILL.md) | 产品规格（业务层）：目标、角色与流程、故事、规则、边界与验收。不写接口与实现 |
| [`tech-spec`](skills/tech-spec/SKILL.md) | 技术规格：须已有产品规格。写架构、接口与数据契约、实现决策与测试决策 |
| [`team-git-workflow`](skills/team-git-workflow/SKILL.md) | 建分支、提交、推送、开 PR 或处理冲突前先预检，保护已有改动与共享历史 |

## 建议顺序

意图不清、不知道从哪开始，或一次提出多步产品管理请求时，先用 [`skill-dispatch`](skills/skill-dispatch/SKILL.md) 作入口路由。它只选定下一步该读的 skill，不代替那个 skill 干活。

worth-it-or-not 给出「可以继续谈方案」，或用户明确拍板继续谈之后，再按需进入 product-design-philosophy / product-research，然后 product-spec，最后 tech-spec。

思路混乱、问题本身还没说清时，[`skill-dispatch`](skills/skill-dispatch/SKILL.md) 把下一步交给 [`structured-thinking`](skills/structured-thinking/SKILL.md)，由它把问题定义和判断整理清楚，再进入或与这些产品 skills 一起推进。

判断停在「先补齐这几件事再谈」或「建议不做」时，体验打磨和规格留在 worth-it-or-not。tech-spec 只实现已有产品规格。

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

[`evals/evals.json`](evals/evals.json) 覆盖本套件：worth-it-or-not（首轮与作答后路径）、skill-dispatch、structured-thinking、product-design-philosophy、product-spec、tech-spec、team-git-workflow，以及 product-research。提示为中文用户口吻，assertions 对照各 skill 的对外契约。可按 skill-creator 流程跑 benchmark。

## License

MIT © 2026 Izelzzz
