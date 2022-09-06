# GitHub Action to synchronise forks

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

  - [Example Workflow file](#example-workflow-file)
  - [Inputs](#inputs)
  - [GitHub Token](#github-token)
    - [Pull from public repository and push to current repository](#pull-from-public-repository-and-push-to-current-repository)
    - [Pull from private repository and/or push to other repository](#pull-from-private-repository-andor-push-to-other-repository)
  - [Example: Update multiple branches](#example-update-multiple-branches)
- [License](#license)
- [No affiliation with GitHub Inc.](#no-affiliation-with-github-inc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Example Workflow file

```yaml
jobs:
  update_external_airflow_fork:
    runs-on: ubuntu-latest
    steps:
      - uses: TobKed/github-forks-sync-action@master
        with:
          github_token: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
          upstream_repository: apache/airflow
          target_repository: TobKed/airflow
          upstream_branch: master
          target_branch: master
          force: true
          tags: true
```

### Inputs

| name | value | default | description                                                                                                                                                                                                                                            |
| ---- | ----- | ------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| github_token | string | | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}`.                                                                                                                                                                              |
| upstream_repository | string | | Repository name. If you want to pull from private repository, you should make a [personal access token](https://github.com/settings/tokens) and use it as the `github_token` input.                                                                    |
| target_repository | string | | Repository name. Default or empty repository name represents current github repository. If you want to push to other repository, you should make a [personal access token](https://github.com/settings/tokens) and use it as the `github_token` input. |
| upstream_branch | string | 'master' | Source branch from which changes will be pushed.                                                                                                                                                                                                       |
| target_branch | string | 'master' | Destination branch to push changes.                                                                                                                                                                                                                    |
| force | boolean | false | Determines if force push is used.                                                                                                                                                                                                                      |
| tags | boolean | false | Determines if `--follow-tags --tags` is used.                                                                                                                                                                                                          |

### GitHub Token

GitHub Token is required to authenticate operations on the repository/repositories.
It should be stored as a secret.
To learn more about creating and using secrets check the [official docs](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets).

#### Pull from public repository and push to current repository

GitHub automatically creates a `GITHUB_TOKEN` secret to use in your workflow.
You can use the `GITHUB_TOKEN` to authenticate in a workflow run.
`github_token` input can be passed in as `${{ secrets.GITHUB_TOKEN }}`.
To learn more about this secret check the [official docs](https://docs.github.com/en/actions/configuring-and-managing-workflows/authenticating-with-the-github_token).

#### Pull from private repository and/or push to other repository

Create Personal Access Token (PAT) with repo permissions and store it as a secret.
Then it can be passed as in the example below:

```yaml
github_token: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
```

To learn more about this creating PAT check the [official docs](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token).

### Example: Update multiple branches

To update multiple branches you can use matrix to parametrize it ([Create a build matrix and define variations for each job - GitHub Docs](https://docs.github.com/en/actions/using-jobs/using-a-build-matrix-for-your-jobs)).

```yaml
name: Sync all branches
on:
  workflow_dispatch:

jobs:

  generate-matrix:
    name: Generate matrix of branches
    runs-on: ubuntu-latest
    outputs:
      matrix: ${{ steps.set-matrix.outputs.matrix }}
    steps:
      - name: Set matrix of branches
        id: set-matrix
        run: |
          upstream_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_UPSTREAM_REPOSITORY}.git"

          # these jq scripts will produce the same matrix jobs by default
          # choose the one that works for any additional values that you may need to build your matrix with
          jq_script='{ "branch": [inputs | split("\n") | .[] | gsub(".*refs/heads/"; "")] }'   # {"branch":["$branch_name_1","$branch_name_2"]}
          # jq_script='[inputs | split("\n") | .[] | gsub(".*refs/heads/"; "") | { "branch": . }]' # [{"branch":"$branch_name_1"},{"branch":"$branch_name_2"}]

          JSON="$(git ls-remote --heads "$upstream_repo" | jq -McnR "$jq_script")"

          # debug matrix pretty json formatted output
          jq --monochrome-output . -- <<< "$JSON"

          echo "::set-output name=matrix::$( echo "$JSON" )"

        env:
          INPUT_GITHUB_TOKEN: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
          INPUT_UPSTREAM_REPOSITORY: apache/airflow

  update_external_airflow_fork:
    runs-on: ubuntu-latest
    needs: generate-matrix
    strategy:
      matrix: ${{fromJson(needs.generate-matrix.outputs.matrix)}}
      fail-fast: false
    steps:
      - uses: TobKed/github-forks-sync-action@master
        with:
          github_token: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
          upstream_repository: apache/airflow
          target_repository: TobKed/airflow
          upstream_branch: ${{ matrix.branch }}
          target_branch: ${{ matrix.branch }}
          force: true
          tags: true
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

## No affiliation with GitHub Inc.

GitHub are registered trademarks of GitHub, Inc. GitHub name used in this project are for identification purposes only. The project is not associated in any way with GitHub Inc. and is not an official solution of GitHub Inc. It was made available in order to facilitate the use of the site GitHub.
