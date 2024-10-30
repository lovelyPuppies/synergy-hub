#!/usr/bin/env fish
# 🧪 fish prototypes/_initialization/ubuntu/fish_test/scope.fish
# ⚓ https://fishshell.com/docs/current/language.html#variables-scope
function test_scope
    # Global variable, accessible outside the function
    set -g gv_in_function "Hi"
    
    # Regular variable, defaults to global scope since it's not limited
    set v_in_function "Hi"
    
    # Local variable, only accessible within this function
    set -l lv_in_function "Hi"
    
    # Display information about the variable scopes
    echo ""

    # Variable inside for loop, treated as a function-local variable
    for i in (seq 1 1)
        set -l lv_in_loop "Hello"
        set v_in_loop "Hello"
    end
    
    # Variable inside if statement, also function-local
    if test $status -eq 0
        set -l lv_in_if "Hello"
        set v_in_if 10 "Hello"
    end
    
    # Display function-local variables, including loop and if statement variables
    echo "in Loop - lv: '$lv_in_loop',  v: $v_in_loop"
    echo "in Condition - lv: '$lv_in_if',  v: $v_in_if"
end


test_scope
echo "in Function v: '$v_in_function',  gv: $gv_in_function"