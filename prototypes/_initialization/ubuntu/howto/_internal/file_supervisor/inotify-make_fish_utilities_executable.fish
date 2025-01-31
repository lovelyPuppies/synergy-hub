#!/usr/bin/env fish
# 📅 Written at 2025-01-12 16:39:12

# Set directory to be watched
set GENERAL_FISH_SCRIPT_DIR (dirname (dirname (dirname (realpath (status filename)))))/general

# Start real-time monitoring
inotifywait --monitor --event create --event modify --format '%w%f' $GENERAL_FISH_SCRIPT_DIR | while read FILE
    # Check condition: Ensure the file has a .fish extension and is a regular file
    if test (string match -r '\.fish$' $FILE) -a -f $FILE
        chmod u+x $FILE
        echo "Changed permissions for $FILE"
    end
end
