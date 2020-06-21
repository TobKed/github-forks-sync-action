#!/bin/sh
set -e

INPUT_TARGET_BRANCH=${INPUT_TARGET_BRANCH:-master}
INPUT_UPSTREAM_BRANCH=${INPUT_UPSTREAM_BRANCH:-master}
TARGET_REPOSITORY=${INPUT_TARGET_REPOSITORY:-$GITHUB_REPOSITORY}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
_FORCE_OPTION=''

echo "Synchronizing repostiory ${TARGET_REPOSITORY}:${INPUT_TARGET_BRANCH} with ${INPUT_UPSTREAM_REPOSITORY}:${INPUT_UPSTREAM_BRANCH}";

[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".' 1>&2;
    exit 1;
};

[ -z "${INPUT_UPSTREAM_REPOSITORY}" ] && {
    echo 'Missing input "upstream_repository' 1>&2;
    echo '  e.g. "upstream_repository: TobKed/github-forks-sync-action".' 1>&2;
    exit 1;
};

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi

if ${INPUT_TAGS}; then
    _TAGS='--tags'
fi

upstream_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_UPSTREAM_REPOSITORY}.git"
upstream_dir=${INPUT_UPSTREAM_REPOSITORY##*/}
target_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${TARGET_REPOSITORY}.git"

git clone ${upstream_repo}
cd ${upstream_dir}
git push $_FORCE_OPTION --follow-tags $_TAGS ${target_repo} ${INPUT_UPSTREAM_BRANCH}:${INPUT_TARGET_BRANCH}
