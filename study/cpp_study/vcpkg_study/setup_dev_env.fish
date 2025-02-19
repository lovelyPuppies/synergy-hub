#!/usr/bin/env fish
# 📅 Written at 2025-02-19 21:10:54
echo "⚙️  Setup User-specific Project Development Environment"

set template_env_file_name ".template.env"
set env_file_name ".env"
echo "Finding `$template_env_file_name` file ..."
if test -e $template_env_file_name; and not test -e $env_file_name
    echo "  Copy `$template_env_file_name` to `$env_file_name`"
    cp $template_env_file_name $env_file_name
else
    set current_pwd (pwd)
    echo "  Already `$env_file_name` file configured or not required in current path: $current_pwd."
end
echo ""

set template_cmake_user_preset_file_name "CMakeUserPresets.template.json"
set cmake_user_preset_file_name "CMakeUserPresets.json"
echo "Finding `$template_cmake_user_preset_file_name` file ..."
if test -e $template_cmake_user_preset_file_name; and not test -e $cmake_user_preset_file_name
    echo "  Copy `$template_cmake_user_preset_file_name` to `$cmake_user_preset_file_name`"
    cp $template_cmake_user_preset_file_name $cmake_user_preset_file_name
else
    set current_pwd (pwd)
    echo "  Already `$cmake_user_preset_file_name` file configured or not required in current path: $current_pwd."
end
