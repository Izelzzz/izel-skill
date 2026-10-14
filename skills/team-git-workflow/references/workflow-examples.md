# 完整流程与特殊场景

直推、PR、侧分支难以归类，或用户的几句话指向不同交付方式时，阅读本文件。先用 `skills/team-git-workflow/SKILL.md` 的五步走一遍，再用下面最接近的一则核对。没有一则能对上时，停下来询问。不要选「开 PR」作为默认解。

本文件的命令是该场景下允许的动作。场景没有写出的写操作不要追加。

## 1. 直推到 feature/global，不要 PR

**用户：** 「在 Izelzzz/izel-skill 里加上一份 skill。直接推到 `feature/global`，不要开 PR。」

**五步：**

1. 意图是留存改动并交付。
2. 工作分支模式。指定工作分支是 `feature/global`。不创建侧分支。
3. 只涉及这一份 skill 与 README 里对应的一行时，一次提交。说明写明新增了什么。
4. 直推授权成立：点名了 `feature/global`，要求推送，并要求不要开 PR。commit 之后 `git push origin feature/global`。不调用创建 PR 的工具。
5. 确认本地与远程都没有本次留下的 `cursor/…` 分支。

当前若不在 `feature/global` 上，且工作区没有用户未提交改动，先切回 `feature/global` 再改文件。

## 2. 要求改完，但没有推送授权

**用户：** 「把分支命名那一段写进文档。」没有出现目标分支上的推送，也没有说不要开 PR。

**五步：**

1. 意图是留存改动。
2. 工作分支模式。本仓库留在 `feature/global`。
3. 一个主题一次提交。提交前按 `commit-rules.md` 检查。
4. 直推授权不成立。PR 条件不成立。可以 commit，不 push，不开 PR。若环境必须推送才能交付，停下来询问目标分支以及是否直推。
5. 不创建、不保留侧分支。

「推上去」但没有点名分支：同样停下来询问。不要把 `feature/global` 以外的仓库也推到 `feature/global`。

## 3. 开 PR 合入受保护分支

**用户：** 「开一个 PR，合入 `main`。」

**五步：**

1. 意图是交付到受保护分支。
2. 侧分支模式。从指定工作分支拉出符合 `branch-rules.md` 的名字，例如 `docs/git-workflow`。
3. 在侧分支上按主题提交。
4. PR 条件成立。按 `pr-rules.md` 填写标题与三段正文，通过 `validate-pr.py` 之后再创建 PR。基分支是用户点名的 `main`。不要把 `feature/global` 直接合并进 `main`。
5. PR 合入之后，删除本地与远程的 `docs/git-workflow`。合入前不要删，避免 PR 失去头分支。

用户只说「合入主干」、没有点名 `main` 或 `master`：询问目标分支，得到名字再创建 PR。

## 4. 一次任务里两件不相关的改动

**用户：** 「给 team-git-workflow 补一节清理规则，另外把 product-spec 的术语表例子换掉。」并授权直推 `feature/global`、不要 PR。

**五步：**

1. 意图是留存两件独立改动并直推。
2. 工作分支模式，`feature/global`。
3. 两次提交。第一次只含 team-git-workflow 的清理规则。第二次只含 product-spec 的术语表。两则说明各自写明改了什么。不要夹带无关格式化。
4. 两次提交都在 `feature/global` 上之后，一次 `git push origin feature/global`。不开 PR。
5. 不留侧分支。

用户没有授权直推时：两次 commit 可以留在本地，不 push。

## 5. 已经站在 cursor/ 侧分支上

**用户：** 授权直推 `feature/global`、不要 PR。当前分支是 `cursor/add-skill-ede9`，其上有本次任务的提交。

**五步：**

1. 意图是把已完成的提交交到指定工作分支。
2. 工作分支模式。`cursor/add-skill-ede9` 不是用户要求的侧分支。
3. 不在 `cursor/…` 上追加新提交。主题若已经分成合格的提交，保持该粒度。
4. 在 `feature/global` 上 cherry-pick 属于本次任务的提交，然后 `git push origin feature/global`。不开 PR。cherry-pick 冲突时按 `safety-rules.md` 停止。
5. cherry-pick 并推送成功之后：

```bash
git branch -d cursor/add-skill-ede9
git push origin --delete cursor/add-skill-ede9
```

远程没有该分支时，只删本地。不要删除 `feature/global`。

## 6. 工作区已有用户未提交的修改

**用户：** 授权直推 `feature/global`。任务开始时 `git status` 显示 `skills/product-spec/SKILL.md` 已有未提交修改，作者不是本次任务。本次任务要改的是 `skills/team-git-workflow/`。

**五步：**

1. 意图是留存本次 skill，同时碰到了用户改动。
2. 两条路径不重叠时，留在 `feature/global`。不要 `stash`、不要 `restore` 用户的 `product-spec` 文件。
3. 只 `git add` 本次 `team-git-workflow` 与 README 中对应的那一行。提交说明不描述用户的 product-spec 修改。
4. 推送前再次 `git status` 与 `git diff`。确认用户的修改仍在工作区、不在本次提交里，再 `git push origin feature/global`。
5. 不留侧分支。

本次必须修改 `skills/product-spec/SKILL.md`，而该文件已有用户改动：停止，列出该路径，询问保留哪一侧。得到回答之前不要写这个文件。

## 7. 用户要求 force-push

**用户：** 「普通推送被拒绝了。对 `feature/global` force-push。」

这是对本轮、本分支、force-push 的明确同意。安全规则满足之后，只执行：

```bash
git push --force-with-lease origin feature/global
```

同意里没有出现 `main` 或 `master` 时，不要对这两条分支 force-push。用户只说「推不上去你处理一下」、没有点名 force-push：按 `safety-rules.md` 停止并询问，不要执行上面的命令。

## 8. 直推和开 PR 两句话都有

**用户：** 「直接推到 `feature/global`，不要开 PR。另外开个 PR 让别人评审。」

两句分别指向直推与 PR，不能同时执行。读完本则之后仍然互相冲突。停下来，请用户选定一种交付：只直推 `feature/global`，或从 `feature/global` 拉侧分支开 PR。在回答之前不要 push，也不要创建 PR。

## 9. 点名直推 main

**用户：** 「直接推到 `main`，不要开 PR。」

直推授权指向 `main`，且用户点名了 `main`。按安全规则，这仍只是普通 push，不是 force-push。工作区与 `main` 的关系先用只读命令核对。推送会被拒绝时停止并报告，不要 force-push。

用户说「推到主干」但没有写出 `main` 或 `master`：不要推送。询问分支名。

其他仓库没有 `Izelzzz/izel-skill` 这个远程时，不要把 `feature/global` 当作它的指定工作分支。先按 `branch-rules.md` 的认定顺序找文档；找不到就询问。
