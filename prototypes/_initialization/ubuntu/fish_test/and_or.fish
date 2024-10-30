#!/usr/bin/env fish
# Written at 📅 2024-11-13 17:06:25

echo Hi; or echo "Bye"; and echo "I don't want this operation when in success operation, but performed."
echo Hi; or begin
    echo "Bye"
    ; and echo "run proprocess when previous \$status return not != 0"
end


: ' 🧪 
- The `or` operator only executes the command following it if the previous command fails (non-zero exit status).
- The `and` operator only executes the command following it if the previous command succeeds (zero exit status).
- In this script, `or echo "Bye"` does not execute because `echo Hi` succeeded. 
  This is the expected (successful) behavior, meaning the fact that `echo "Bye"` is not executed is the correct and intended outcome.
- Since `or echo "Bye"` is not executed as expected, the `and` operator runs its command ("I don\'t want this operation when in success operation, but performed.")
  because the previous command did not trigger the `or` clause, allowing the `and` to execute as part of the intended flow.
- The execution of the `and` command is therefore normal and expected, as the non-execution of the `or` clause confirms the intended success.
'