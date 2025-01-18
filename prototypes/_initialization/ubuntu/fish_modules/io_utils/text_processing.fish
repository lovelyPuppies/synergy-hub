#!/usr/bin/env fish

function prettify_indent_via_pipe
    : '
    📑 Summary:
        This command processes the piped input, removing specific indentation and trailing spaces based on the indentation level detected in the input.
    
        The function "prettify_indent_via_pipe" takes input from a pipe and processes it with "awk".

    🚧 Prerequisites
        - This function requires input to be piped to it, typically structured as a multi-line block.
        - To achieve the intended indented formatting, the input should start and end with empty lines.
            The first line is removed entirely, and indentation is removed from all subsequent lines based on the indentation level of the second line.
        - You must use "gawk" for compatibility, as this function relies on GNU Awk features. 📅 2024-11-13 16:15:41
            On Jetson Nano, the default awk may not be GNU Awk (gawk), leading to unexpected behavior.
            To check if gawk is being used, run `awk --version`. If GNU Awk is not installed, use:
                sudo apt install -y gawk
            Installing gawk will set awk to automatically call gawk, ensuring this function behaves as expected.
    🔧 Usage
        echo "
        <text>
        " | prettify_indent_via_pipe        
    🛍️ e.g.
        # Load modules
        set -x FISH_MODULES_DIR prototypes/_initialization/ubuntu/fish_modules
        source $FISH_MODULES_DIR/io_utils/text_processing.fish

        # Example usage with multi-line input
        echo "
        <text>
        " | prettify_indent_via_pipe

        # Example usage with multi-line input
        echo "
        <text>
        " | prettify_indent_via_pipe

        # 📍 If you want to save output with new line, you must addtionally use split0
        set replacement_text (echo "
            If true, allows remote access to the desktop via the RFB\
            protocol. Users on remote machines may then connect to the\
            desktop using a VNC viewer.
        " | prettify_indent_via_pipe | string split0)
        echo $replacement_text

    ❔ Note on Input Stream Consumption:
        In Fish, functions can automatically receive piped input as their standard input, making it accessible to any commands within the function.
        Fish processes each command within the function 🚣 sequentially.
        When a function receives input from a pipe, each command 🚣 can consume part or all of the input stream.
        
        Here, "awk" consumes the entire input as it processes it,
        🚣 so any subsequent commands within the function would not receive the original piped input unless duplicated.

    
    ❔ About awk Processing Flow:
        💡 "awk" reads the input line by line in sequence, applying pattern-action pairs to each line one at a time.
        As each line is read in order, the special variable "NR" (Number of Records) increases sequentially,
        allowing line-specific conditions like NR == 1 or NR == 2 to be evaluated exactly once per line as they appear.
        Each condition is evaluated independently for every line, and based on these conditions,
        "awk" determines which specific actions to apply to the current line.
    '

    awk '
      NR == 2 { indent = match($0, /[^ ]/) - 1 }
      NR > 1 { sub("^ {" indent "}", "") }
      NR == 1 { next }
      { gsub(/[[:blank:]]*$/, ""); print }
    '

    : '❓ About awk ~ statements ...
    ❔ Format: awk \'PATTERN { ACTION }\' input_file

    ❔ NR == 2 { indent = match($0, /[^ ]/) - 1 }
      NR == 2 checks if the current line is the second line.
      { indent = match($0, /[^ ]/) - 1 } defines the action to take when NR == 2 is true.
    
      Breaking down match($0, /[^ ]/) - 1:
        match($0, /[^ ]/): Finds the position of the first non-space character in $0, which represents the current line.
          - $0 is the entire content of the current line.
          - /[^ ]/ is a regular expression pattern:
            - [^ ] means "any character that is not a space."
            - This pattern helps locate where the actual text starts on the line, skipping initial spaces.
          - match($0, /[^ ]/) returns the position (starting from 1) of the first non-space character.
        -1: Subtracting 1 from this position gives the number of leading spaces (or indent level) before the first non-space character, which we assign to indent.
    
    ❔ NR > 1 { sub("^ {" indent "}", "") }
      NR > 1 applies the action { ... } to all lines except the first one.
      { sub("^ {" indent "}", "") } removes leading spaces from each line based on the indent level calculated on the second line.

      🚣 Breaking down sub("^ {" indent "}", ""):
        sub(...): Performs a substitution on the current line.
        Format: sub(regex, replacement, target)
          - regex: The regular expression pattern to match.
          - replacement: The string to replace the matched pattern.
          - target: The string to operate on (⚖️ default is $0, the entire current line).

        "^ {" indent "}":
          - "^ ": Anchors the pattern to the start of the line, so ^ means "start of the line."
          - {" indent "}: Dynamically inserts the value of the variable `indent`, representing the number of spaces to remove.
            - For example, if indent = 8, this pattern becomes "^ {8}", meaning "start of the line followed by exactly 8 spaces."

        "": The empty string "" is the replacement, meaning we are removing the matched spaces from the start of each line.

      🛍️ e.g. when indent = 8:
        Input:
          "        Line 1"
          "        Line 2"
          "        Line 3"
        Steps:
          - On Line 2: sub("^ {8}", "") removes 8 spaces, resulting in "Line 2".
          - On Line 3: sub("^ {8}", "") removes 8 spaces, resulting in "Line 3".
        Output:
          "Line 2"
          "Line 3"

    ❔ NR == 1 { next }
      NR == 1 checks if the current line is the first line.
      { next } tells awk to skip any further processing for the current line and move directly to the next line.
    
    ❔ { gsub(/[[:blank:]]*$/, ""); print }
      { ... } applies this action to every line.
      gsub(/[[:blank:]]*$/, "") removes trailing whitespace from the current line.
        - gsub is a function that replaces all occurrences of a pattern within a line.
        - /[[:blank:]]*$/ matches any whitespace at the end of the line.
          - [[:blank:]]* matches any sequence of spaces or tabs.
          - $ anchors the match to the end of the line.
        - "" replaces the matched whitespace with an empty string (effectively removing it).
      print outputs the cleaned-up line.
    '
end




# Function to insert or modify the interactive block in Fish config
function update_fish_interactive_block
    : '
    🚧 Prerequisites
        - the variable "FISH_CONFIG_PATH" must be defined.
            set -Ux FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"

    🔧 Usage
        update_fish_interactive_block [OPTIONS]

    📋 Options
        -u, --unique-comment    (Required) A unique comment string to ensure idempotency (avoids duplicate insertion).
        -c, --contents          (Required) The block of text to insert into the interactive block.

    🛍️ Examples
        # Example 1: Insert a new function into the interactive block of Fish config
        set unique_comment "# Add alias for peazip"
        set alias_function (echo "
            function peazip
                flatpak --user run io.github.peazip.PeaZip \$argv
            end
        " | prettify_indent_via_pipe | string split0)

        # Call the function to update the config
        update_fish_interactive_block --unique-comment="$unique_comment" --contents="$alias_function"

    📅 Written at 2024-12-25 23:01:27
    '

    # Parse arguments using argparse
    argparse 'c/contents=!test -n "$_flag_value"' \
        'u/unique-comment=!test -n "$_flag_value"' \
        -- $argv
    or begin
        echo "❓ Error: Invalid arguments for update_fish_interactive_block."
        return 1
    end

    # Check if required arguments are provided
    if not set -q _flag_contents; or not set -q _flag_unique_comment
        echo "❓ Error: Both --contents (-c) and --unique-comment (-u) are required."
        return 1
    end

    # Assign parsed arguments to variables
    set unique_comment $_flag_unique_comment
    set contents $_flag_contents

    # Temporary file
    set tmp_file (mktemp)

    # Check if the unique comment already exists
    if not grep -q "$unique_comment" $FISH_CONFIG_PATH
        # Use awk to insert the new block
        awk -v unique_comment="$unique_comment" -v contents="$contents" '
          BEGIN {
              interactive_block_start = "if status --is-interactive"
              found = 0
          }
          $0 ~ interactive_block_start {
              print $0
              found = 1
              next
          }
          found && $0 ~ /^end$/ {
              print "    " unique_comment
              n = split(contents, lines, "\n")
              for (i = 1; i <= n-1; i++) {
                  print "    " lines[i]
              }
              found = 0
          }
          { print }
      ' $FISH_CONFIG_PATH >$tmp_file

        # Overwrite the original config file with the updated content
        mv $tmp_file $FISH_CONFIG_PATH
    else
        echo "Content with the same unique comment already exists in Fish config."
        echo "  Unique comment: '$unique_comment'"
    end
end
