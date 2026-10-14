# Commit 格式、粒度与提交前检查

每次 `git commit` 之前阅读本文件。本文件是 `team-git-workflow` 的提交规则。入口与决策顺序在 `skills/team-git-workflow/SKILL.md`。

`scripts/validate-commit-msg.sh` 只拒绝空说明，以及整句只有 `update` / `fix` 的说明。脚本退出码为 0，只表示躲过了这份机械检查。说明是否写明改了什么，仍由本节判断。

## 粒度

一个逻辑主题一次提交。一次任务只有一个主题时，做一次提交。

拆开的情况：

- 同一任务改了两套互不相关的 skill。
- 功能改动之外还有与该功能无关的文档、重命名或重构。
- 用户把两件独立的事放在同一句话里，两件事可以分开评审、分开回退。

用户明确允许把清理和功能放在一起时，可以同一次提交。提交说明里写上功能改了什么，也写上清理了什么。

用户未允许时，不要夹带顺手清理：不要把无关格式化、无关重命名、无关依赖锁定文件放进功能提交。那些改动要么另一次提交并在说明里写明主题，要么不提交。

不要 `git commit --amend` 用户已有的提交，除非用户在本轮明确要求修改那一次提交。不要用 `--no-verify` 跳过检查，除非用户在本轮明确要求跳过。

## 提交说明

主题行使用祈使句，或使用中文。两种都可以。主题行必须让读者看出改了什么：改动的对象，以及做了哪一种变更。

主题行可以带类型前缀，也可以不带。前缀不是必须。若使用，形式为 `type: 说明` 或 `type(scope): 说明`。`type` 取 `feat`、`fix`、`chore`、`docs`、`refactor`、`test`、`style`、`perf`、`build`、`ci`、`revert` 之一。`scope` 只含小写字母、数字、`_`、`.`、`/`、`-`。真正受检的是冒号后面的说明。

正文可选。有正文时，用空行与主题行分开，补充主题行没写完的范围。主题行本身仍然要能独立说明改了什么。

### 必须拒绝的说明

下列主题行不要提交：

- 空说明、只有空白、只有注释行。
- 整句（或类型前缀之后）只有空洞词：`update`、`updates`、`updated`、`updating`、`fix`、`fixed`、`fixes`、`fixing`、`fixup`。
- 整句只是这些词的堆叠或明显空洞短语，例如 `fix bug`、`minor fix`、`quick fix`、`update readme`、`update code`、`fix typo`、`fix: update`。

大小写与句末的 `.` `!` `。` `！` 不影响判定。`Update`、`Fix.` 与 `fix` 同样拒绝。

说明里出现 `fix` 或 `update` 这个词，并不自动拒绝。`fix(commit): reject empty subjects` 写明了拒绝的对象，可以提交。`修复登录死循环` 写明了对象和现象，可以提交。

### 脚本会拒绝的短语

`validate-commit-msg.sh` 把主题行规范化之后（去掉可选类型前缀、去掉句末标点、压缩空白、忽略大小写），整句落在下表则退出码 1。

英文词全部属于空洞词（冠词与连词 `a` `an` `the` `of` `to` `for` `and` `or` `in` `on` 不算出内容）时，同样退出码 1。因此 `fix the bug` 会被拒绝。含有汉字且汉字本身写出了改动时，不因旁边的 `fix` / `update` 被拒绝。

| 类别 | 短语 |
|------|------|
| 单词 | `update` `updates` `updated` `updating` `fix` `fixed` `fixes` `fixing` `fixup` |
| 堆叠 | `fix update` `update fix` |
| 空洞短语 | `minor fix` `small fix` `quick fix` `bug fix` `fix bug` `fix bugs` `fix code` `fix issue` `fix issues` `fix typo` `typo fix` `various fixes` `update code` `update files` `update docs` `update readme` `minor update` `small update` `quick update` `minor changes` `small changes` |

脚本不要求英文最少词数。`Add skill` 这种短句能通过脚本，但仍可能没写明是哪一项。Agent 看到对象或结果不清楚时，改写主题行再提交，不要因为脚本退出码为 0 就停。

### 写明改了什么

合格的主题行同时点出对象和变更。读者不看 diff 也能知道这次提交动了哪一块。

| 主题行 | 判定 |
|--------|------|
| `Add team-git-workflow skill` | 合格。对象是该 skill，变更是新增。 |
| `新增团队 Git 工作流 skill` | 合格。 |
| `fix(commit): reject empty subjects` | 合格。对象是提交说明检查，变更是拒绝空主题。 |
| `补充分支命名校验` | 合格。 |
| `update` | 拒绝。 |
| `Fix.` | 拒绝。 |
| `fix: update` | 拒绝。 |
| `update readme` | 拒绝。没有写明 README 哪一条变成了什么。 |
| `Add skill` | 脚本可能通过。对象不清，改写成带 skill 名的说明再提交。 |

## 提交前检查

每次 `git commit` 之前按顺序做完：

1. `git status`。确认当前分支是标准流程第 2 步选定的那一条。
2. `git diff` 与 `git diff --cached`。确认即将提交的文件都属于这一个主题。
3. 把与主题无关、且用户未允许夹带的修改移出本次提交。
4. `git log -8 --oneline`。仓库近期说明是英文祈使句。本次仍可用英文祈使句或中文，主题行必须写明改了什么。
5. 按上一节写说明。空说明与只有 `update` / `fix` 的说明不要提交。
6. 运行 `skills/team-git-workflow/scripts/validate-commit-msg.sh`，参数为说明文件或 `-m`。退出码非 0 则改写说明。脚本缺失时，仍按第 5 步拒绝空洞说明。

检查完再 `git add` 本次主题的文件并提交。不要把整个工作区无差别 `git add -A`，除非 `git status` 里的每一项都属于这一个主题。

## 校验脚本

```bash
skills/team-git-workflow/scripts/validate-commit-msg.sh <消息文件>
skills/team-git-workflow/scripts/validate-commit-msg.sh -m "Add team-git-workflow skill"
printf '%s\n' "新增团队 Git 工作流 skill" | skills/team-git-workflow/scripts/validate-commit-msg.sh
```

消息文件按 Git `commit-msg` hook 的习惯处理：忽略空行与以 `#` 开头的注释行，取第一条有效行作为主题行。主题行之后的正文不参与空洞词检查。

退出码：`0` 通过机械检查；`1` 拒绝。

脚本未接入本地 hook 或 CI 时，第 5 步仍然执行。接入之后，hook 调用本脚本，失败则这次提交不成立。
