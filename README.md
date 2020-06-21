# GitHub Action to synchronise forks 

### Inputs

| name | value | default | description |
| ---- | ----- | ------- | ----------- |
| github_token | string | | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}`. |
| upstream_repository | string | | Repository name. If you want to pull from private repository, you should make a [personal access token](https://github.com/settings/tokens) and use it as the `github_token` input. |
| target_repository | string | | Repository name. Default or empty repository name represents current github repository. If you want to push to other repository, you should make a [personal access token](https://github.com/settings/tokens) and use it as the `github_token` input. |
| upstream_branch | string | 'master' | Source branch from which changes will be pushed. |
| target_branch | string | 'master' | Destination branch to push changes. |
