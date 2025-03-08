#!/usr/bin/env fish

# 📅 Written at 2024-12-17 20:34:28 

function on_interrupt
    echo -e "\nScript interrupted. Exiting..."
    # Kill all child processes in the same process group
    kill -- -$fish_pid
    exit 1
end
trap on_interrupt SIGINT


# Note that: Use it in workspace's root!!!
echo "Current working directory:" (pwd)
echo "Is this the correct workspace root? (y/n)"
while true
    read --local confirmation
    switch $confirmation
        case y
            break
        case n
            echo "  Operation canceled. Exiting without changes."
            exit
        case '*'
            echo "  ❓ Invalid input. Please enter 'y' or 'n'."
    end
end

echo ""

# Prompt for BASE_DIR
while true
    echo "Enter the base directory for driver modules:"
    echo "  🛍️ e.g. study/bsp_study/raspberry_pi/drivers"
    read -g BASE_DIR

    # Check if the directory is valid
    if test -d $BASE_DIR
        echo "  Valid directory: $BASE_DIR"
        break
    else
        echo "  ❓ Invalid directory: $BASE_DIR. Please try again."
    end
end

# Output and temporary directory setup
set OUTPUT compile_commands.json
set TEMP_DIR (mktemp -d)


# Iterate through driver directories
echo "Generating compile_commands.json for all drivers..."
for dir in (find $BASE_DIR -mindepth 1 -maxdepth 1 -type d)
    echo "Processing $dir"
    cd $dir

    # Check for Makefile existence
    if test -f Makefile
        echo "Running compiledb make in $dir..."
        # Generate compile_commands.json
        compiledb make >/dev/null
        # cp compile_commands.json $TEMP_DIR/(basename $dir)_compile_commands.json
        # rm -f compile_commands.json

        # Clean up build artifacts
        make clean >/dev/null
    else
        echo "No Makefile found in $dir, skipping."
    end

    cd - >/dev/null
end


# Clean old compile_commands.json
# echo "Cleaning old compile_commands.json files..."
# rm -f $OUTPUT

# # Merge all compile_commands.json files
# echo "Merging all compile_commands.json files..."
# jaq -s add $TEMP_DIR/*.json >$OUTPUT
# rm -rf $TEMP_DIR

# echo "Done. Combined compile_commands.json created at $PWD/$OUTPUT."
