# GitHub Action to synchronise forks 

### Example Workflow file

```yaml
jobs:
  update_external_airflow_fork:
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

### GitHub Token

#### Pull from public repository and push to current repository

GitHub automatically creates a `GITHUB_TOKEN` secret to use in your workflow. 
You can use the `GITHUB_TOKEN` to authenticate in a workflow run. 
`github_token` input can passed in `${{ secrets.GITHUB_TOKEN }}`

#### Pull from private repository and/or push to other repository

Create Personal Access Token ([link](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)), 
store it as a secret ([link](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets)).
Then it can be passed as shown in the example.

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

## No affiliation with GitHub Inc.

GitHub are registered trademarks of GitHub, Inc. GitHub name used in this project are for identification purposes only. The project is not associated in any way with GitHub Inc. and is not an official solution of GitHub Inc. It was made available in order to facilitate the use of the site GitHub.
