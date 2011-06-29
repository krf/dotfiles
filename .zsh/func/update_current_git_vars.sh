unset __CURRENT_GIT_BRANCH
unset __CURRENT_GIT_BRANCH_STATUS
unset __CURRENT_GIT_BRANCH_STATUS_AMOUNT
unset __CURRENT_GIT_BRANCH_IS_DIRTY

unset __CURRENT_GIT_BRANCH_REMOTE
unset __CURRENT_GIT_BRANCH_MERGE

# optimization: do not run in ~
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ "$GIT_ROOT" = "$HOME" ]]; then
    return
fi

local st="$(git status -uno 2>/dev/null)"
if [[ -n "$st" ]]; then
	local -a arr
	arr=(${(f)st})

	if [[ $arr[1] =~ 'Not currently on any branch.' ]]; then
		__CURRENT_GIT_BRANCH='no-branch'
	else
		__CURRENT_GIT_BRANCH="${arr[1][(w)4]}";
	fi

	if [[ $arr[2] =~ 'Your branch' ]]; then
		if [[ $arr[2] =~ 'ahead' ]]; then
			__CURRENT_GIT_BRANCH_STATUS_AMOUNT=$(echo $arr[2] | cut -d' ' -f 9)
			__CURRENT_GIT_BRANCH_STATUS='ahead'
		elif [[ $arr[2] =~ 'diverged' ]]; then
			local amount1=$(echo $arr[3] | cut -d' ' -f 4)
			local amount2=$(echo $arr[3] | cut -d' ' -f 6)
			__CURRENT_GIT_BRANCH_STATUS_AMOUNT="${amount1},${amount2}"
			__CURRENT_GIT_BRANCH_STATUS='diverged'
		else
			__CURRENT_GIT_BRANCH_STATUS_AMOUNT=$(echo $arr[2] | cut -d' ' -f 8)
			__CURRENT_GIT_BRANCH_STATUS='behind'
		fi
	fi

	if [[ ! $st =~ 'nothing to commit' ]]; then
		__CURRENT_GIT_BRANCH_IS_DIRTY='1'
	fi

	# branch info
	__CURRENT_GIT_BRANCH_REMOTE="$(git config branch.${__CURRENT_GIT_BRANCH}.remote)"
	__CURRENT_GIT_BRANCH_MERGE="$(git config branch.${__CURRENT_GIT_BRANCH}.merge  | sed 's,refs/heads/,,')"
fi
