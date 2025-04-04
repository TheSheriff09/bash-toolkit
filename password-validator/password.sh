#!/bin/bash

show_usage() {
    echo "Usage: $0 [-h] [-v] [-t] password"
    echo "Options:"
    echo "  -t : Check the validity of the provided password."
    echo "  -h : Display detailed help from help.txt."
    echo "  -v : Display the script's authors and version."
    exit 1
}

show_help() {
    if [[ -f help.txt ]]; then
        cat help.txt
    else
        echo "Error: help.txt not found."
    fi
    exit 0
}

show_version() {
    echo "Password Validator v1.0"
    echo "Author: Rihem"
    exit 0
}

validate_password() {
    local password="$1"
    local errors=()

    if [[ -z "$password" ]]; then
        echo "Error: No password provided."
        show_usage
    fi
    
    if [[ ${#password} -lt 8 ]]; then
        errors+=("Password must be at least 8 characters long.")
    fi
    
    if ! [[ "$password" =~ [0-9] ]]; then
        errors+=("Password must contain at least one digit (0-9).")
    fi
    
    if ! [[ "$password" =~ [@#\$%\&\*\+\=\-] ]]; then
        errors+=("Password must contain at least one special character from the set: @, #, \$, %, \&, \*, \+, \-, =.")
    fi    

    if check_dictionary "$password"; then
        errors+=("Password contains a dictionary word or a sequence of four or more consecutive characters.")
    fi

    if [[ ${#errors[@]} -gt 0 ]]; then
        echo "Errors:"
        for error in "${errors[@]}"; do
            echo "  - $error"
        done
        exit 1
    fi

    echo "Password is valid and strong!"
    exit 0
}

check_dictionary() {
    local password="$1"
    local dict_file="/usr/share/dict/words"
    
    for i in $(seq 0 $((${#password} - 4))); do
        local substring="${password:i:4}"
        local lower_substring=$(echo "$substring" | tr 'A-Z' 'a-z')

        if grep -q "^$lower_substring\$" "$dict_file"; then
            echo "Error: Password contains the dictionary word: $lower_substring"
            return 0
        fi
    done

    return 1
}

while getopts ":htv" opt; do
    case "$opt" in
        h) show_help ;;
        v) show_version ;;
        t) shift; validate_password "$1" ;;
        *) show_usage ;;
    esac
done

show_usage

