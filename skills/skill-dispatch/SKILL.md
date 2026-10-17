---
name: skill-dispatch
description: >
  用户不清楚该用套件里哪一个 skill、不知道从哪开始、要走产品流程，或一次提出含糊的、多步的产品管理请求时，使用本 skill 选定下一步该读哪一个 skill。
  当用户说「该用哪个 skill」「从哪开始」「帮我走产品流程」「不确定先做什么」「先做什么」「接下来用哪个」「这事该走哪条」「帮我排一下步骤」「入口是哪个」时使用本 skill。
  思路混乱、问题本身还没说清、需要梳理逻辑，或用户说「结构化思考」「帮我理一理」「想法很散」「把问题说清楚」时，使用本 skill，并把下一步交给 structured-thinking。
  即使用户没有点名 skill-dispatch，只要意图横跨值不值得做、体验打磨、调研、产品规格、技术规格中的多步，入口不清，或思考还没收成一个问题，也应先使用本 skill，再去读被选中的 skill。
  用户已经点名某一个具体 skill（含 structured-thinking、「结构化思考」）时，直接 Read 那个 skill。当前请求是 Git 时，直接使用 team-git-workflow。
---

# 技能调度（skill-dispatch）

本 skill 只选定下一步该运行的套件 skill，然后把控制权交出去。值不值得做、体验打磨、调研、产品规格、技术规格、结构化思考和 Git 各自有完整 skill。选完之后，Read 目标 skill 并完整遵循它。交出的三行只说明选了谁；步骤以那个 skill 的正文为准。

## 已点名则直接交出

用户已经说出套件中某一个 skill 的名字，或明确别名（「值不值得做」「产品价值主张」「竞品调研」「产品规格」「技术规格」「Git 工作流」「结构化思考」「梳理思路」「把问题说清楚」）时，立刻 Read 那个 skill 并遵循它。点名优先于建议顺序：前置不满足时，由目标 skill 自己停下。

## 只在这些 skill 之间选

| 顺序 | Skill | 它是下一步，当 |
|------|--------|----------------|
| 正交 | `team-git-workflow` | 当前请求是 Git：分支、commit、push、PR、冲突、rebase、merge、reset |
| 正交 | `structured-thinking` | 思路混乱，问题本身还没定义清楚，或需要把零散想法收成问题定义、判断和可验证的下一步 |
| 1 | `worth-it-or-not` | 已有待判定的需求或方案，值不值得做尚未闭合 |
| 2a | `product-design-philosophy` | 方向已定，要打磨体验、文案、结构或路径 |
| 2b | `product-research` | 要行业摸底、竞品，或带来源的调研结论 |
| 3 | `product-spec` | 要写或评审业务层产品规格；不写 API、schema 或实现 |
| 4 | `tech-spec` | 要技术规格，且已有 product-spec；不得另立业务范围 |

`structured-thinking` 与 `team-git-workflow` 一样留在产品顺序旁边。问题尚未成形时先读它。问题已经清楚到可以判定、打磨、调研或写规格时，走对应的产品闸门。worth-it-or-not 仍是最早的产品闸门。

2a 与 2b 按需选用，可跳过，彼此不阻塞。只在这一句确实是打磨或调研时才选它们。

## 怎么选

按下面顺序做，命中即停。

1. **当前动作是 Git。** 交给 `team-git-workflow`。它留在产品顺序旁边。同一句话里产品工作还没做、Git 只是收尾时，先走产品闸门；真正要执行 git 时再交这个 skill。
2. **问题本身还没成形。** 想法零散、问题还没定义，或这一轮要的是梳理逻辑、结构化思考，把散点收成问题定义、判断和可验证的下一步 → `structured-thinking`。同一句话里已经是一个待判定的需求或方案时，继续用下面的产品闸门。
3. **多个产品 skill 都适用。** 选产品顺序里最早一个尚未完成的闸门：worth-it-or-not，然后按需的 product-design-philosophy 或 product-research，然后 product-spec，最后 tech-spec。后面的 skill 默认前面的闸门已经闭合。打磨和规格接在 worth-it-or-not 闭合之后。
4. **用对话和仓库里已有的事实判断闸门**，判断留在目标 skill 里做：
   - 还没有「可以继续谈方案」，用户也还没明确拍板继续谈，或用户仍在改问题本身 → `worth-it-or-not`。判断闭合前，打磨和规格留在 worth-it-or-not。
   - 方向已定，且这句是在打磨体验、文案、结构或路径 → `product-design-philosophy`。
   - 这句是在要行业、竞品或带来源的结论 → `product-research`。2a 与 2b 都像当前句的主题时，选更直接的那一个。
   - 要业务层规格（目标、角色、故事、规则、边界、验收），且值不值得做已闭合 → `product-spec`。
   - 要 API、字段、schema、实现或测试决策：已有产品规格 → `tech-spec`；没有 → `product-spec`。
5. **仍然分不清。** 只问一个短澄清问题，然后按答案路由。问完即按答案交出。

## 交出

选定后只输出下面三行，然后立刻 Read 并遵循目标 skill。本仓库用 `skills/<name>/SKILL.md`；已安装到 agent 时用该 skill 的安装路径。

```text
选用：<name>
原因：<一句话，指向正交的思考或 Git、最早未完成的产品闸门，或用户点名>
下一步：Read skills/<name>/SKILL.md（或安装路径）并完整遵循
```

Read 之后按那个 skill 行事。步骤以那个 skill 的正文为准。
