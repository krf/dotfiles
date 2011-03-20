# Adjustable constants
local VERBOSE=1

if [ -n "$__CURRENT_GIT_BRANCH" ]; then
	local s="("
	s+="$__CURRENT_GIT_BRANCH"
	case "$__CURRENT_GIT_BRANCH_STATUS" in
		ahead)
		s+="↑"
		;;
		diverged)
		s+="↕"
		;;
		behind)
		s+="↓"
		;;
	esac
	if [ -n "$__CURRENT_GIT_BRANCH_STATUS_AMOUNT" ]; then
		s+="$__CURRENT_GIT_BRANCH_STATUS_AMOUNT"
	fi
	if [ -n "$__CURRENT_GIT_BRANCH_IS_DIRTY" ]; then
		s+="⚡"
	fi
	s+=")"
 
	if [ $VERBOSE = 1 ] && [ -n "$__CURRENT_GIT_BRANCH_MERGE" ]; then
		printf " %s→%s" $s $__CURRENT_GIT_BRANCH_REMOTE
	else
		printf " %s" $s
	fi
fi
