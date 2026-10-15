# 提交格式、粒度与提交前检查

每次 `git commit` 之前阅读本文件。决策顺序在 `SKILL.md`。仓库自己的提交约定优先于这里的默认格式。

`scripts/validate-commit-msg.sh` 检查的是默认格式，并拒绝笼统摘要。仓库使用别的约定时，按仓库约定写，并运行仓库自己的检查。脚本退出码 0 只表示默认格式的机械检查过了，不表示这次 diff 该提交。

## 说明格式

仓库没有提交约定时，主题行使用：

```text
<type>(<scope>): <imperative summary>
```

`scope` 可以省略，写成 `<type>: <imperative summary>`。可选的 `!` 放在冒号前，表示破坏性变更，不能代替摘要。

类型只有：

| 类型 | 用于 |
|------|------|
| `feat` | 新能力 |
| `fix` | 缺陷修复 |
| `refactor` | 不改变外部行为的结构调整 |
| `docs` | 文档 |
| `test` | 测试 |
| `chore` | 杂项维护 |
| `perf` | 性能 |
| `build` | 构建系统或依赖打包 |
| `ci` | 持续集成 |

`hotfix` 可以作为分支类型，不是提交类型。生产修复的提交仍用 `fix`。

摘要用祈使语气，点明改动对象和做了什么。中文摘要同样要让读者不看 diff 就知道改了哪一块。英文不要用过去式凑主题行。

正文可选。有正文时，用空行与主题行分开。主题行本身仍然要能独立说明这次提交。

### 必须拒绝的写法

- 空说明、只有空白、只有注释行。
- 缺少类型，或类型不在上表中。
- 摘要笼统，例如整句只有 `update`、`fix bug`、`changes`，或同等的「更新」「修复」「改动」。
- 把没有运行的测试写成已经通过。提交说明不汇报测试结果。PR 正文的验证节写应测清单，不写未核实的通过或未测。
- 编造工单号、issue 链接或变更编号。脚本不会替你核实编号；写上编号之前，你必须已经在仓库或工单系统里看到它。

| 主题行 | 判定 |
|--------|------|
| `feat(auth): add review summary endpoint` | 符合默认格式 |
| `fix: refresh oauth tokens before expiry` | 符合。scope 省略 |
| `docs(team-git-workflow): 重写团队 Git 工作流` | 符合。摘要写明了对象 |
| `fix(auth)!: rotate signing keys` | 符合。`!` 不代替摘要 |
| `update` | 拒绝。没有类型，摘要笼统 |
| `fix bug` | 拒绝 |
| `feat: update` | 拒绝。摘要笼统 |
| `feat: changes` | 拒绝 |
| `Add team git workflow skill` | 拒绝。缺少类型 |
| `hotfix: patch login` | 拒绝。`hotfix` 不是提交类型 |

## 粒度

一次提交一个连贯的逻辑改动。读者应能单独 revert 这一次，而不拆散无关的工作。

拆开这些情况：

- 无关的缺陷修复、格式化和功能改动落在同一次任务里。
- 两套可以分开评审、分开回退的改动。

与这次改动对应的测试和文档，放进同一次提交。不要为了「纯代码」把测试留到下一次。

不要提交：

- 密钥、凭据、令牌、私钥。
- 环境文件，以及含有本地机密的配置。
- 构建产物和其他生成垃圾。
- 与本次任务无关的用户改动。

没有授权时，不要改写已经共享的历史。这包括对已推送提交执行 `git commit --amend`、rebase 后强推，以及 reset 到会丢掉已发布提交的位置。即使用户要求修改最后一次提交，也要先确认那次提交还没有推到共享分支；已经推送时，按 `safety-rules.md` 取得对改写历史的授权。

不要使用 `--no-verify` 跳过钩子，除非用户在本轮明确要求跳过，并且这样做不违反平台的安全限制。

## 提交前

按这个顺序做完再提交：

1. `git status --short --branch`。确认当前分支就是本次允许写入的分支。
2. `git diff` 与 `git diff --cached`。确认即将进入提交的内容属于这一个逻辑改动。
3. 只暂存本次任务的文件或 hunk。可能存在无关改动或用户原有改动时，不要 `git add .`，不要 `git add -A`。
4. 再次查看 `git diff --cached`。排除密钥、无关文件、意外删除和生成垃圾。
5. 运行仓库要求的测试或检查。没跑的项目留到完成报告里说明，不要写成通过。
6. 按上一节写说明。使用默认格式时，运行 `scripts/validate-commit-msg.sh`。退出码非 0 就改写说明，不要带着失败提交。
7. 自己能向别人讲清这次提交改了什么之后，再执行 `git commit`。

消息文件按 commit-msg 钩子的习惯处理：忽略空行和以 `#` 开头的注释，用第一条有效行作为主题行。

```bash
scripts/validate-commit-msg.sh <消息文件>
scripts/validate-commit-msg.sh -m "fix: refresh oauth tokens before expiry"
printf '%s\n' "docs(team-git-workflow): 重写团队 Git 工作流" | scripts/validate-commit-msg.sh
```

退出码：`0` 通过机械检查；`1` 拒绝。
