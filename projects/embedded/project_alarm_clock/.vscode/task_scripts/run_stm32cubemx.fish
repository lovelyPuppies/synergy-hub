#!/usr/bin/env fish
# Written at 📅 2024-11-27 00:24:38
: ' 
🔄 Attempts
    - STM32CubeMX must be run from the specified base directory to avoid JRE-related errors.
    - Additionally, it requires a display, so using the --no-gui argument will result in an error.
        Minimal popups are unavoidable in this case.
'

# Ensure WORKSPACE_FOLDER is set
if not set -q WORKSPACE_FOLDER
    echo "Error: WORKSPACE_FOLDER is not set."
    exit 1
end

# Define STM32CubeMX directory and script path
set STM32CubeMX_DIR "$HOME/STM32CubeMX"
set SCRIPT_PATH "$STM32CubeMX_DIR/project_setup.script"

# Navigate to STM32CubeMX directory
cd $STM32CubeMX_DIR

# Generate the project setup script
echo "config load $WORKSPACE_FOLDER/project.ioc
project generate ./
exit" >$SCRIPT_PATH

# Run STM32CubeMX with the generated script
./STM32CubeMX -q project_setup.script

# Return to the previous directory
cd -
