#!/usr/bin/env fish
# Updated at 📅 2025-01-12 21:52:37
: '
💡 Note: Use `set -l` to declare `script_dir` as a local variable. 📅 2024-11-25 00:22:29
    This ensures that the variable is scoped only to this script and does not interfere with other scripts or overwrite global variables when using `source`.

🛍️ e.g.
    # Load modules
    set -l script_dir (dirname (realpath (status filename)))
    source $script_dir/fish_modules/_import_all.fish
'


# Define script_dir
set -l script_dir (dirname (realpath (status filename)))
set -g script_file_name (realpath (status filename))

# Define a function to source each module and check if it exists
function safe_source --argument-name file_path
    # Skip sourcing this fish file itself
    # echo (basename $script_file_name)
    # echo $file_path
    if test $file_path = $script_file_name
        return
    end


    # Check if the file exists
    if not test -e $file_path
        echo "Error: Module '$file_path' not found."
        return 1
    end

    # Source the file if it exists
    source $file_path
end

# Find and source each .fish file recursively in the directory, except this fish file itself
for file in (find $script_dir -name '*.fish')
    safe_source $file
end
