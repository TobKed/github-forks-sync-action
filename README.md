# GitHub Action to synchronise forks 

### Example Workflow file

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: TobKed/github-forks-sync-action@master
        with:
          github_token: ${{ secrets.GH_TOKEN }}
          upstream_repository: apache/airflow
          target_repository: TobKed/airflow
          upstream_branch: master
          target_branch: master
          force: true
          tags: true
```

### Inputs

| name | value | default | description |
| ---- | ----- | ------- | ----------- |
| github_token | string | | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}`. |
| upstream_repository | string | | Repository name. If you want to pull from private repository, you should make a [personal access token](https://github.com/settings/tokens) and use it as the `github_token` input. |
| target_repository | string | | Repository name. Default or empty repository name represents current github repository. If you want to push to other repository, you should make a [personal access token](https://github.com/settings/tokens) and use it as the `github_token` input. |
| upstream_branch | string | 'master' | Source branch from which changes will be pushed. |
| target_branch | string | 'master' | Destination branch to push changes. |
| force | boolean | false | Determines if force push is used. |
| tags | boolean | false | Determines if `--tags` is used. |
