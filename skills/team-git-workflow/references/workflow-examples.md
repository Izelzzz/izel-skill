# 工作流示例

交付方式难以归类，或可能命中 Izelzzz/izel-skill 的仓库特例时，阅读本文件。先走完 `SKILL.md` 的决策流程，再用最接近的一则核对。没有一则能对上时，停下来询问。

本文件没有写出的写操作不要追加。示例里的分支名和说明要换成这次任务的真实名称。

## 1. 一般仓库：任务分支、提交、推送、PR

**适用：** 仓库没有把某条共享分支指定为工作分支。用户要求修一个缺陷并开 PR 合入已确认的基线 `main`。

1. 预检。工作区里的既有改动不要带上。基线用命令确认，不要猜。
2. 从 `main` 创建 `fix/oauth-token-refresh`。运行 `scripts/validate-branch.sh fix/oauth-token-refresh`。
3. 一次提交：`fix(auth): refresh oauth tokens before expiry`。只暂存这次修复的文件。
4. 只推送 `fix/oauth-token-refresh`。
5. 按 `pr-rules.md` 写标题和正文，通过 `scripts/validate-pr.py` 之后再创建 PR。目标是用户点名的 `main`。
6. 核实真实 URL。不合入。不删除 `fix/oauth-token-refresh`。

任务做完但用户没有要求 PR 时：不要创建 PR。分支可以留在本地；推送到远程也要符合用户对这次交付的授权。不要改成直推 `main`。

## 2. 工作区里已有用户改动

**适用：** 任务开始时 `git status` 已有不是本次写出的修改。

路径与本次任务不重叠：不要 stash、不要 restore、不要把那些路径放进 `git add`。提交说明不描述那些改动。推送或开 PR 前再看一次 `git diff`，确认它们仍在工作区、不在本次提交里。

路径重叠，或无法按 hunk 分开：停止，列出路径，说明两侧分别是什么，询问如何保留。得到回答之前不要写这些文件。

## 3. 推送被拒绝

**适用：** 普通 `git push` 因非快进或分支保护被拒绝。

停止并报告完整原因。`git fetch` 后查看远程比本地多出的提交。不要 `--force`，不要 `--force-with-lease`，不要重试同一条命令。用户随后对本分支明确授权 force-push、且政策和必要性都成立时，才按 `safety-rules.md` 使用 `--force-with-lease`。

## 4. 冲突

**适用：** 合并、rebase、cherry-pick 或写入文件时两侧不一致。

列出路径。用户已经说明保留方式，或两侧差异与任务目标无歧义对应时，按那个意图解决，跑测试，检查最终 diff。否则询问。不要加 `--ours` 或 `--theirs`。不要在冲突还在时报告成功。

## 5. 危险操作没有授权

**适用：** 工作区不干净，切换或拉取被未提交改动挡住；或推送失败。

不要 `reset --hard`，不要 `clean -fd`，不要 force-push。说明挡住命令的路径和推送失败的原因，询问用户要保留什么。工具的默认权限不是授权。

## 6. 本仓库特例：Izelzzz/izel-skill

**适用：** 远程 URL 或仓库名是 Izelzzz/izel-skill。其他仓库到此为止，不要继续套用。

指定工作分支是 `feature/global`。用户没有点名别的分支时，在这条分支上修改和提交。`validate-branch.sh` 对这个名字返回 1 是预期结果，不要因此另建 `feat/global`。

**直推。** 用户授权把改动推到 `feature/global`，并且不要 PR 时：

1. 在 `feature/global` 上按 `commit-rules.md` 提交。
2. `git push origin feature/global`。
3. 不要创建 PR，不要更新 PR，不要调用会打开 PR 的工具。
4. 这是普通推送。推送被拒绝时按第 3 则停止，不要 force-push。

用户没有给出这个授权时：可以在 `feature/global` 上提交，不要推送，不要改成开 PR。环境必须推送才能交付时，停下来询问。

用户既要求直推到 `feature/global` 且不要 PR，又要求另开 PR：两条都是本轮明确指令，并且互相冲突。询问用户选定一种。回答之前不要推送，也不要创建 PR。

**已授权的清理。** 仅当本次任务使用了未经授权的 `cursor/*` 侧分支时，删除这些残留。这是该仓库已经成立的清理政策，不是一般规则。不要删除 `feature/global`、`main`、`master`，或本次任务没有用过的分支。其他仓库的 `cursor/*` 不要按这一则删除。

删除前：

```bash
git log --oneline feature/global..cursor/<任务侧分支>
```

- 没有独有提交：核对分支全名后，删除本地和远程的这条 `cursor/*`。
- 有独有提交，且每一笔都属于本次任务：在 `feature/global` 上 cherry-pick 这些提交，再在直推授权下执行普通 `git push origin feature/global`。成功之后删除这条 `cursor/*` 的本地和远程引用。
- cherry-pick 发生冲突，或提交里混有无法归入本次任务的工作：停止并询问。不要 `-D`，不要 force-push。

```bash
git branch -d cursor/<任务侧分支>
git push origin --delete cursor/<任务侧分支>
```

远程没有该分支时，只删本地。`git branch -d` 被拒绝时停止并报告，不要改成强制删除。
