# 贡献

改 skill、发布版本、把规格落盘或跑评测时读本文件。安装与使用见 [README.md](README.md)。

## 改 skill 与版本

`skills/` 或任何含 `SKILL.md` 的路径有改动时，在同一个 PR 里把 `VERSION` 写成新的 `X.Y.Z`，并在 `CHANGELOG.md` 加上标题 `## [X.Y.Z]`。

```bash
scripts/bump-version.sh X.Y.Z "说明"
```

`scripts/bump-version.sh` 写入 `VERSION`，在 `CHANGELOG.md` 插入该版本小节，并把 README「版本」里的「当前版本是 **X.Y.Z**」改成同一版本号。

`.github/workflows/version-check.yml` 调用 `scripts/check-version-bump.sh`。技能目录有改动时，这次变更里的 `VERSION` 与基线不同，`CHANGELOG.md` 有改动，并且含有 `## [X.Y.Z]`。

## 发布

合入 `main` 之后，按当前 `VERSION` 打标签并推送：

```bash
git tag "v$(cat VERSION)"
git push origin "v$(cat VERSION)"
```

标签与 `VERSION` 一致，形如 `v0.1.0`。`.github/workflows/release.yml` 用 `CHANGELOG.md` 里该版本的小节创建 GitHub Release。

## 文档落盘

产品规格与技术规格默认写在 `docs/`。文件名形如 `docs/<短标题>-产品规格.md`、`docs/<短标题>-技术规格.md`，见 [`docs/README.md`](docs/README.md)。

落盘步骤以 skill 正文为准：

- [`skills/product-spec/SKILL.md`](skills/product-spec/SKILL.md)
- [`skills/tech-spec/SKILL.md`](skills/tech-spec/SKILL.md)

## 评测

用例在 [`evals/evals.json`](evals/evals.json)。按 skill-creator 的 benchmark 流程运行这些用例。
