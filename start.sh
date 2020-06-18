#!/bin/sh
set -e

INPUT_BRANCH=${INPUT_BRANCH:-master}
TARGET_REPOSITORY=${INPUT_TARGET_REPOSITORY:-$GITHUB_REPOSITORY}

echo "Synchronizing repostiory ${INPUT_UPSTREAM_REPOSITORY} with ${TARGET_REPOSITORY}";

[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".' 1>&2;
    exit 1;
};

[ -z "${INPUT_UPSTREAM_REPOSITORY}" ] && {
    echo 'Missing input "upstream_repository' 1>&2;
    echo '  e.g. "upstream_repository: TobKed/github-forks-sync-action".' 1>&2;
    exit 1;
};

upstream_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_UPSTREAM_REPOSITORY}.git"
upstream_dir=${INPUT_UPSTREAM_REPOSITORY##*/}
target_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${TARGET_REPOSITORY}.git"

git clone ${upstream_repo}
cd ${upstream_dir}
git push --force ${target_repo} master
