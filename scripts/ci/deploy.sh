#!/bin/bash
# vim: ai:ts=8:sw=8:noet
set -eufCo pipefail
export SHELLOPTS
IFS=$'\t\n'

MANIFESTS_PATH="${MANIFESTS_PATH:-./manifests}"
GIT_BEFORE_COMMIT_SHA=${GIT_BEFORE_COMMIT_SHA:-}
GIT_DEFAULT_BRANCH=${GIT_DEFAULT_BRANCH:-master} # In case our default branch is different (e.g main).


case "${1:-"dry-run"}" in
"run")
    #kahoy apply \
    #    --include-changes \
    #    --git-before-commit-sha "${GIT_BEFORE_COMMIT_SHA}" \
    #    --git-default-branch "${GIT_DEFAULT_BRANCH}" \
    #    --fs-new-manifests-path "${MANIFESTS_PATH}" \
    #    --fs-exclude "secret"
    echo "NOOP until we have a running cluster on CI"
    ;;
"diff")
     #kahoy apply \
     #    --diff \
     #    --include-changes \
     #    --git-before-commit-sha "${GIT_BEFORE_COMMIT_SHA}" \
     #    --git-default-branch "${GIT_DEFAULT_BRANCH}" \
     #    --fs-new-manifests-path "${MANIFESTS_PATH}" \
     #    --fs-exclude "secret" | colordiff
     echo "NOOP until we have a running cluster on CI"
    ;;
"dry-run")
    kahoy apply \
        --dry-run \
        --include-changes \
        --git-before-commit-sha "${GIT_BEFORE_COMMIT_SHA}" \
        --git-default-branch "${GIT_DEFAULT_BRANCH}" \
        --fs-new-manifests-path "${MANIFESTS_PATH}" \
        --fs-exclude "secret"
    ;;
"sync-all")
    echo "This should be without dry-run, but we don't have a running cluster"
    kahoy apply \
       --dry-run \
       --mode="paths" \
       --fs-old-manifests-path /dev/null \
       --fs-new-manifests-path "${MANIFESTS_PATH}" \
       --fs-exclude "secret"
    ;;
*)
    echo "ERROR: Unknown command"
    exit 1
    ;;
esac
