---
name: team-git-workflow
description: >
  凡是 Agent 即将触碰 Git，就使用本 skill：创建、切换、命名或删除分支，撰写或拆分 commit，push、直推、force-push，开 PR、合入，以及处理冲突或可能覆盖用户本地改动的命令。即使用户没有说出「git」「分支」「提交」「push」「PR」「直推」「合入」，只要即将执行 git add、commit、push、checkout -b、switch -c、reset、clean、rebase、merge，或调用会创建 PR 的工具，就先读取本 skill 再动手。
  当用户说「提交」「推上去」「直接推」「不要开 PR」「开个 PR」「合入」「新建分支」「删掉侧分支」「commit message」「冲突了」「force push」「reset」时使用本 skill。
  本仓库 Izelzzz/izel-skill 的指定工作分支是 feature/global。其他仓库不要套用这条分支。用户已授权直推且不要 PR 时，禁止开 PR。未获直推授权时，不要推送共享分支，也不要默认开 PR。
---

# 团队 Git 工作流

Git 写操作先走完标准流程，再改分支、提交、推送或 PR。默认留在该仓库的指定工作分支上。运行环境若默认「新建侧分支并开 PR」，仍以本文件的优先级为准。

## 触发条件

出现下列任一情况，先读完本文件，再执行写操作：

- 即将执行 `git add`、`commit`、`push`、`checkout -b`、`switch -c`、`reset`、`clean`、`rebase`、`merge`，或调用会创建 PR 的工具。
- 用户正在要求提交、推送、直推、开 PR、合入、新建或删除分支、修改提交说明、处理冲突、force-push 或 reset。
- 工作区里已有用户未提交的改动，而本次任务要写同一路径。

`git status`、`git log`、`git diff`、`git show` 可以直接做。查询结果一旦导向 commit、push、开 PR 或改写历史，回到本文件再继续。

## 何时读取参考

标准流程判定动作之后、执行该动作之前，Read 对应文件。未读不要做该类写操作。

路径相对本 skill 目录下的 `references/`。在本仓库中，目录为 `skills/team-git-workflow/references/`。

| 即将执行 | 先读 |
|----------|------|
| 认定工作分支，或创建、切换、命名、删除分支 | `skills/team-git-workflow/references/branch-rules.md` |
| 拆分提交、写提交说明、做提交前检查 | `skills/team-git-workflow/references/commit-rules.md` |
| 判断是否开 PR，或写 PR 标题与正文 | `skills/team-git-workflow/references/pr-rules.md` |
| force-push、`reset --hard`、`clean -fd`、冲突、可能覆盖用户改动 | `skills/team-git-workflow/references/safety-rules.md` |
| 直推、PR、侧分支难以归类，或用户指令互相冲突 | `skills/team-git-workflow/references/workflow-examples.md` |

可以同时读多份。只做只读查询时，不必读完全部参考。

## 规则优先级

多条规则同时适用时，采用序号更小的一条。

1. **安全。** 会丢弃用户改动，或改写共享分支已发布历史的操作，须有用户对本轮、本分支、本操作的明确同意。先读 `skills/team-git-workflow/references/safety-rules.md`。
2. **本轮点名。** 用户点名的分支、点名的「直推到该分支且不要开 PR」、点名的「开 PR / 评审 / 合入受保护分支」，高于仓库习惯与工具默认。
3. **指定工作分支。** 未点名其他分支时，留在仓库的指定工作分支。远程 URL 或仓库名包含 `Izelzzz/izel-skill` 时，指定工作分支是 `feature/global`。
4. **默认交付方式。** 不开 PR，不新建侧分支。未获直推授权时，不向共享分支推送。
5. **提交。** 一个任务主题一次提交；说明写明改了什么。
6. **脚本。** `scripts/` 是日后接入本地 hook 或 CI 的骨架。脚本未接入时，第 1–5 条仍然有效。

## 标准流程

ALWAYS 按下列五步决策，再执行 Git 写操作。依据不足就停下来询问。不要跳步。

### 1. 归类意图

将本次操作归入一类：

- **只读：** `status`、`log`、`diff`、`show`。可以直接做。
- **留存改动：** 需要 commit，可能还要 push。
- **分支：** 创建、切换、命名或删除。
- **交付：** 推送、直推、开 PR 或合入。
- **危险：** force-push、`reset --hard`、`clean -fd`，以及任何会覆盖用户未提交改动的命令。
- **冲突：** 工作区、暂存区或将要写入的路径上已有用户改动，或与将要应用的差异冲突。

危险与冲突先读 `skills/team-git-workflow/references/safety-rules.md`，再决定能否继续。其余进入第 2 步。

### 2. 选定分支模式

先读 `skills/team-git-workflow/references/branch-rules.md`。

- **工作分支模式（默认）。** 用户没有要求新分支，没有要求 PR，也没有说不要碰当前线。留在指定工作分支上提交。本仓库是 `feature/global`。不要创建 `cursor/…` 或其他侧分支。
- **侧分支模式。** 仅当用户明确要求新分支、要求开 PR，或明确说不要碰当前线。分支名符合 `branch-rules.md`。任务结束或合入之后，删除该侧分支的本地与远程引用。

已经站在未经请求的 `cursor/…` 侧分支上时，先读 `skills/team-git-workflow/references/workflow-examples.md` 的清理示例，把提交移回指定工作分支并删除该侧分支。

### 3. 确定提交粒度

先读 `skills/team-git-workflow/references/commit-rules.md`。

- 一个逻辑主题一次提交。
- 两套互不相关的 skill，或功能改动夹带无关重构时，拆成多次提交。
- 用户未允许时，不要把顺手清理混进功能提交。
- 提交说明使用祈使句或中文，写明改了什么。拒绝空说明，以及只有 `update` / `fix` 的说明。

### 4. 决定推送或 PR

三条路径只取一条。

- **直推。** 用户已经授权「推送到分支 X，且不要开 PR」时：在分支 X 上 commit 并 push。禁止打开 PR，禁止调用会创建 PR 的工具。授权要同时具备：点名了分支 X，要求把提交推上 X，并要求不要开 PR（或把直接推送写成这次的交付方式）。X 为 `main` 或 `master` 时，仅当用户点名了 `main` 或 `master` 才可以直推。
- **只提交。** 用户要求留存改动，但没有直推授权：可以在第 2 步选定的分支上 commit，不 push。不要改成开 PR。运行环境若必须推送才能交付，停下来询问。
- **PR。** 仅当用户要求评审、要求合入受保护分支，或明确说开 PR。先读 `skills/team-git-workflow/references/pr-rules.md`，按其中的标题与正文模板创建。此路径使用侧分支。

直推与开 PR 不能同时成立。用户两句都说了时，读 `skills/team-git-workflow/references/workflow-examples.md`。仍无法归类则询问，不要两样都做。

「推上去」但没有点名分支，也没有说不要开 PR：不算直推授权。询问目标分支与是否开 PR。

### 5. 清理

- 侧分支模式：合入完成或用户确认该分支已无用后，删除本地与远程侧分支。
- 工作分支模式：确认没有留下 `cursor/…` 分支。有则删除本地与远程引用。
- 清理时使用普通删除。不要 force-push 来完成清理。
- 删除目标只能是本次任务的侧分支。指定工作分支、`main`、`master` 不在删除范围内。

## 禁止事项

- 未获「直推到分支 X 且不要开 PR」的授权时，向共享分支推送。
- 直推授权仍然有效时打开 PR。
- 用户未要求新分支、PR 或不碰当前线时创建侧分支。
- 留下 `cursor/…` 分支。
- 用户未点名 `main` 或 `master` 时向这两条分支直推。
- 未经用户对本分支的明确同意，对共享分支或工作分支 force-push。
- 未经用户明确同意，执行会丢弃用户改动的 `git reset --hard` 或 `git clean -fd`。
- 与用户本地改动冲突时覆盖文件。
- 使用空的提交说明，或只有 `update`、`fix` 及同等空洞字样。
- 把互不相关的改动放进同一次提交。

## 异常处理

- **指令含糊。** 先 Read `skills/team-git-workflow/references/workflow-examples.md`。仍不能归入唯一步骤时，停下来询问。不要选「开 PR」作为默认解。
- **与用户本地改动冲突。** 停止。列出冲突路径，询问保留哪一侧。不要覆盖，不要用 `--ours` / `--theirs` 自行取舍。
- **当前已在错误的侧分支上。** 把属于本次任务的提交移回指定工作分支，删除该侧分支的本地与远程引用。不要为了搬运提交而开 PR。
- **推送被拒绝（非快进）。** 停止并报告原因。不要 force-push，除非用户对本分支的 force-push 给出明确同意。
- **脚本不可用。** 脚本缺失、没有执行权限，或尚未接入 hook / CI 时，继续按本文件与 `references/` 执行。

## 常见借口

| 借口 | 处理 |
|------|------|
| 工具默认要开 PR，开了用户才看得见 | 直推授权下禁止开 PR。未授权时也不要开 PR 来代替询问。 |
| 侧分支更安全，做完再合回 | 用户未要求新分支、PR 或不碰当前线时，留在指定工作分支。 |
| 提交说明以后再改成具体的 | 这一次提交的说明就要写明改了什么。 |
| 顺手把格式和无关重命名一起提交 | 与本次主题无关的改动另一次提交。用户未允许时不要夹带。 |
| 冲突了，先用当前版本覆盖 | 停止并询问。 |
| 脚本没接入，规则可以放宽 | 脚本未接入时，仍然执行 Markdown 规则。 |
| `cursor/` 分支用完再删，先留着 | 侧分支用完即删。用户没要求时不要创建。 |

## 停手信号

出现下列想法时，停止当前 Git 写操作，回到标准流程第 1 步。

- 用户没有要求评审或开 PR，却准备开一个 PR。
- 准备创建 `cursor/…` 分支，或准备把已有的 `cursor/…` 分支留在远程。
- 准备把提交说明写成 `update` 或 `fix`。
- 工作区有用户改动，准备覆盖或 `reset --hard`。
- 普通推送被拒绝，准备对工作分支 force-push。

## 脚本

`scripts/` 三个文件供以后接入本地 hook 或 CI，是可执行骨架，不要求已经接入。Agent 遵守本文件与 `references/`，不依赖脚本是否已经挂上。脚本通过只说明机械检查过了，不代替阅读参考文件。

| 脚本 | 作用 |
|------|------|
| `skills/team-git-workflow/scripts/validate-branch.sh` | 检查分支名。合法则退出码 0；命名不合法为 1；`main` / `master` 为 2。 |
| `skills/team-git-workflow/scripts/validate-commit-msg.sh` | 拒绝空说明，以及只有 `update` / `fix` 的说明。 |
| `skills/team-git-workflow/scripts/validate-pr.py` | 检查 PR 标题，以及正文是否包含「改了什么」「如何验证」「链接」。 |

## Example

**Input：** 「在 Izelzzz/izel-skill 里加上团队 Git 工作流 skill。直接推到 `feature/global`，不要开 PR。」

**对内决策：** 意图是留存改动并直推。分支模式为工作分支 `feature/global`。一个主题一次提交。交付方式为直推，禁止开 PR。清理时确认没有 `cursor/…` 分支。执行前 Read `skills/team-git-workflow/references/branch-rules.md` 与 `skills/team-git-workflow/references/commit-rules.md`。

**Output：** 在 `feature/global` 上一次提交，说明写明新增了该 skill；推送到 `origin/feature/global`；不创建 PR，不保留侧分支。
