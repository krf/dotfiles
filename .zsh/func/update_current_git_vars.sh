#!/bin/bash

unset __CURRENT_GIT_BRANCH
unset __CURRENT_GIT_BRANCH_STATUS
unset __CURRENT_GIT_BRANCH_STATUS_AMOUNT
unset __CURRENT_GIT_BRANCH_IS_DIRTY
unset __CURRENT_GIT_BRANCH_REMOTE
unset __CURRENT_GIT_BRANCH_MERGE

unset __CURRENT_GIT_TAG

__CURRENT_GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [[ "$?" -ne "0" ]]; then
    return
fi

# performance bottle-neck, calls git status internally
local diff_files="$(git diff-files --exit-code)"
if [[ -n "$diff_files" ]]; then
    __CURRENT_GIT_BRANCH_IS_DIRTY='1'
fi

__CURRENT_GIT_TAG="$(git describe 2>/dev/null | sed -e 's/-[^-]*$//' )"

local branch="$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
if [[ -z "$branch" || "$branch" == "(no branch)" ]]; then
    return
fi

# check branch status, compare to remote
local ref="$(git symbolic-ref HEAD 2>/dev/null)"
local head="${ref#refs/heads/}"
local remote="$(git config branch.$head.remote)"
local merge="$(git config branch.$head.merge)"
local upstream="$remote/${merge#refs/heads/}"

local upstream_to_head_diff=""
local upstream_to_head="$(git --no-pager log --oneline $upstream..HEAD 2>/dev/null)"
if [[ -n "$upstream_to_head" ]]; then
    upstream_to_head_diff="$(echo $upstream_to_head | wc -l)"
fi

local head_to_upstream_diff=""
local head_to_upstream="$(git --no-pager log --oneline HEAD..$upstream 2>/dev/null)"
if [[ -n "$head_to_upstream" ]]; then
    head_to_upstream_diff="$(echo $head_to_upstream | wc -l)"
fi

__CURRENT_GIT_BRANCH="$branch"
__CURRENT_GIT_BRANCH_REMOTE="$remote"
__CURRENT_GIT_BRANCH_MERGE="$merge"

if [[ -n "$upstream_to_head_diff" && -n "$head_to_upstream_diff" ]]; then
    __CURRENT_GIT_BRANCH_STATUS_AMOUNT="${upstream_to_head_diff},${head_to_upstream_diff}"
    __CURRENT_GIT_BRANCH_STATUS='diverged'
elif [[ -n "$upstream_to_head_diff" ]]; then
    __CURRENT_GIT_BRANCH_STATUS_AMOUNT="${upstream_to_head_diff}"
    __CURRENT_GIT_BRANCH_STATUS='ahead'
elif [[ -n "$head_to_upstream_diff" ]]; then
    __CURRENT_GIT_BRANCH_STATUS_AMOUNT="${head_to_upstream_diff}"
    __CURRENT_GIT_BRANCH_STATUS='behind'
else
    __CURRENT_GIT_BRANCH_STATUS_AMOUNT=""
    __CURRENT_GIT_BRANCH_STATUS='clean'
fi
