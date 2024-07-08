#!/bin/bash

# Define filename and placeholders with values
filename="template.txt"
username="John"
current_date=$(date)
user_id="1234"

# Build replacement string using sed syntax
replace_str=""
replace_str="${replace_str}s/\${USERNAME}/${username}/g;"
replace_str="${replace_str}s/\${DATE}/${current_date}/g;"
replace_str="${replace_str}s/\${USER_ID}/${user_id}/g;"

# Read the file and perform replacements using sed
sed -e "$replace_str" "$filename"