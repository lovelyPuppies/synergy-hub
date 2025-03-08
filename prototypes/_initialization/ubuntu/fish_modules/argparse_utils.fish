#!/usr/bin/env fish
# 📅 Written at 2024-10-28 13:48:11

function exit_if_no_argument_from_argv1
    : '
    🚧 Prerequisites
        - define "usage" function
        - pass argv[1] to function
    🔧 Usage
        exit_if_no_argument_from_argv1 $argv[1]
    🛍️ e.g.
        # Load modules
        set -x FISH_MODULES_DIR prototypes/_initialization/ubuntu/fish_modules
        source $FISH_MODULES_DIR/argparse_utils.fish

        function usage
            echo Hello world
        end

        exit_if_no_argument_from_argv1 $argv[1]
        set main_command $argv[1]
        set --erase argv[1]
    '
    set -l arg $argv[1]
    if test -z "$arg"
        usage; and exit 1
    end
end
