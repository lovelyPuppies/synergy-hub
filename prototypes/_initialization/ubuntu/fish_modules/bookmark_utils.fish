#!/usr/bin/env fish
# Written at 📅 2024-10-28 13:48:11


# bookmark_utils.fish

# Set the default path for Ubuntu bookmarks
# gtk: GIMP(GNU Image Manipulation Program) Toolkit
set -g UBUNTU_BOOKMARKS_PATH "$HOME/.config/gtk-3.0/bookmarks"


# Function to print usage information and exit
function usage
    echo "Usage: add_bookmark_from_local_dir <path_to_add> [optional_bookmarks_path]"
end

# Function to add a bookmark if it doesn't already exist
function add_bookmark_from_local_dir --argument-name local_dir
    : '
    🔧 Usage
        add_bookmark_from_local_dir <path_to_add> [optional_bookmarks_path]
    🛍️ e.g.
        # Load modules
        set -x FISH_MODULES_DIR prototypes/_initialization/ubuntu/fish_modules
        source $FISH_MODULES_DIR/bookmark_utils.fish

        add_bookmark_from_local_path $LOCAL_MOUNT_PATH
        echo "Bookmark update completed!"
    '

    # Check if the required argument is provided
    if test (count $argv) -lt 1
        echo "Error: Missing required argument <path_to_add>"
        usage; and exit 1
    end

    # Set the path to add and the bookmarks path (default if not provided)
    set bookmarks_path (if test (count $argv) -gt 1; echo $argv[2]; else; echo $UBUNTU_BOOKMARKS_PATH; end)

    ## Validate if the provided path is valid
    # (short: -e) - Checks if the path (file or directory) exists.
    if not test -e $local_dir
        echo "Error: Invalid path '$local_dir'. Please provide a valid path."
        exit 1
    end
    ## Convert local path to file URI format
    set file_uri (string replace -r '^/' 'file:///' $local_dir)

    # (short: -F, long: --fixed-strings) - Treat the pattern as a literal string, not a regular expression.
    # (short: -x, long: --line-regexp) - Ensure the whole line matches the pattern exactly.
    # (short: -q, long: --quiet) - Suppress output; only the exit status is used to indicate a match.
    if not grep -Fxq $file_uri $bookmarks_path
        echo "Adding: $file_uri"
        echo $file_uri >> $bookmarks_path
    else
        echo "Bookmark already exists: $file_uri"
    end
end


