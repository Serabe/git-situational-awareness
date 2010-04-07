#!/usr/bin/env bash

PROMPT_GREEN='\['`tput setaf 2`'\]'
PROMPT_PINK='\['`tput setaf 5`'\]'
PROMPT_PLAIN='\['`tput op`'\]'

function in_git_repo {
    [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
}

function git_changed {
    if in_git_repo; then
        if [ "$(git status | grep '# Changed')" ]; then
            echo "+"
        elif [ "$(git status | grep '# Changes')" ]; then
            echo "*"
        fi
    fi
}

function git_branch {
    if in_git_repo; then
        branch=$(git branch | grep "*" | cut -d ' ' -f 2-3)
        if [ "$branch" = "" ]; then
            branch=$(git status | grep "# On branch" | cut -d ' ' -f 4-5)
        fi
        echo $branch
    fi
}

function git_branch_separator {
    if in_git_repo; then
        echo ":"
    fi
}

function git_stash_height {
    if in_git_repo; then
        stash_height="$(git stash list | wc -l | awk '{ print $1 }')"
        if [ $stash_height = "0" ]; then
            stash_height=""
        fi 
        echo "$stash_height"
    fi
}

function git_stash_height_separator {
    if [ "$(git_stash_height)" ]; then
        echo ":"
    fi
}

export HAVE_GIT_SIT_AWARENESS=1


# tweak this as you see fit
export PS1="\[\e[0;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$(git_branch_separator)${PROMPT_PINK}\$(git_changed)${PROMPT_GREEN}\$(git_branch)${PROMPT_PLAIN}\$(git_stash_height_separator)${PROMPT_PINK}\$(git_stash_height)${PROMPT_PLAIN}\$ "

