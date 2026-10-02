# 2026-10-01 — misread "GH API move script"

## Failure

The user asked for the **GH API move script** after repository work. Instead of recalling the existing Kitchen repository-transfer task, a new Python program was produced that copied a directory tree between repositories with the Git Data API.

That was the wrong operation and duplicated machinery Kitchen already had.

## Correct interpretation

In this working context, **GH API move script** means the repository-ownership transfer helper:

`tasks/github-repository-transfer/1.sh`

Its underlying mutation is:

```sh
gh api --method POST "repos/$source_owner/$repository/transfer" \
  -f "new_owner=$destination_owner"
```

The wrapper also:

- unsets ambient `GH_TOKEN` and `GITHUB_TOKEN`;
- verifies the active `gh` login;
- verifies the source is canonical rather than a redirect;
- distinguishes a redirected old destination name from a real destination collision;
- performs one repository-transfer request;
- polls until the exact canonical destination appears.

## Regression rule

When the user says **GH API move script**, **GitHub API move script**, or otherwise refers back to the established move procedure:

1. retrieve `tasks/github-repository-transfer/README.md` and `1.sh`;
2. treat **move** as a whole-repository ownership transfer unless the user explicitly says files/subtree;
3. do not write a new Contents/Git-Data copying script;
4. do not silently substitute clone/push for GitHub's transfer endpoint.

If repository visibility or Connector permissions fail after a transfer, use the separate procedure in:

`tasks/github-chatgpt-codex-connector-access/README.md`
