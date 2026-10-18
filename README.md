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

本仓库按仓库版本整体更新。把已安装的套件同步到当前内容时，重新执行同一条安装命令。这是本仓库套件的推荐更新方式：

```bash
npx skills add Izelzzz/izel-skill
```

安装时加过的参数（例如 `-a`、`-y`）照原样带上。

CLI 不可用时，可以手动复制：

```bash
cp -R skills/* ~/.claude/skills/
cp -R skills/* ./.agents/skills/
```

## 版本

当前版本是 **0.1.0**（[`VERSION`](VERSION)）。

查看本仓库版本：读 [`VERSION`](VERSION)，看 [`CHANGELOG.md`](CHANGELOG.md)，或打开 [Releases](https://github.com/Izelzzz/izel-skill/releases)。也可以直接取远程的 `VERSION`：

```bash
curl -sL https://raw.githubusercontent.com/Izelzzz/izel-skill/main/VERSION
```

`npx skills --version` 与 `npx skills -v` 打印的是 **skills CLI** 的版本。本仓库版本以上面的 `VERSION`、[`CHANGELOG.md`](CHANGELOG.md) 和 [Releases](https://github.com/Izelzzz/izel-skill/releases) 为准。

`npx skills list` 与 `npx skills ls` 列出已安装的 skill 及其路径。

`npx skills update` 按内容哈希更新已安装 skill（可能牵动全局其它 skill）。同步本仓库套件时，用上方「安装」节的重新 `npx skills add Izelzzz/izel-skill`。

维护与发布见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## License

MIT © 2026 Izelzzz
