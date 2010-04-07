#!/usr/bin/env bash

FILE_NAME="git_sit_awareness.sh"

function prompt () {
    if [ "$noprompt" ] && [ "$#" = "1" ]; then
        if [ "$1" = "yes" ]; then
            echo "DEFAULT: yes"
            return 0
        else
            echo "DEFAULT: no"
            return 1
        fi
    fi

    while true; do
        echo "Enter \"yes\" or \"no\": "
        read response
        case $response
        in
            Y*) return 0 ;;
            y*) return 0 ;;
            N*) return 1 ;;
            n*) return 1 ;;
            *)
        esac
    done
}

function ask_append_shell_config () {
    config_string="$1"

    shell_config_file=""
    # use order outlined by http://hayne.net/MacDev/Notes/unixFAQ.html#shellStartup
    if [ -f "$HOME/.bash_profile" ]; then
        shell_config_file="$HOME/.bash_profile"
    elif [ -f "$HOME/.bash_login" ]; then
        shell_config_file="$HOME/.bash_login"
    elif [ -f "$HOME/.profile" ]; then
        shell_config_file="$HOME/.profile"
    elif [ -f "$HOME/.bashrc" ]; then
        shell_config_file="$HOME/.bashrc"
    fi

    echo "    \"$config_string\" will be appended to \"$shell_config_file\"."
    if prompt "no"; then
        if [ "$shell_config_file" ]; then
            echo >> "$shell_config_file"
            echo "$config_string" >> "$shell_config_file"
            echo "Added to \"$shell_config_file\". Restart your shell or run \"source $shell_config_file\"."
            return 0
        else
            echo "Couldn't find a shell configuration file."
        fi
    fi
    return 1
}

cp "$FILE_NAME" ~/."$FILE_NAME"
if [ "$?" = "0" ]; then
    if [ "$HAVE_GIT_SIT_AWARENESS" != "1" ]; then
        ask_append_shell_config "source ~/.$FILE_NAME"
    else
        echo "Restart your shell or run \"source ~/.$FILE_NAME\"."
    fi
else
    echo "Installation failed. Could not write to" ~/."$FILE_NAME".
fi
