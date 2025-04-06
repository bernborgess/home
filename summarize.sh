#!/bin/bash

# Recursively find all specified files starting from the current directory.
find . -type f \( -name "*.c" -o -name "*.h" -o -name "*.py" -o -name "*.rs" -o -name "*.hs" -o -name "*.lean" -o -name "*.rb" -o -name "*.java" -o -name "*.cpp" -o -name "*.hpp" \) | while read -r file; do

  # Determine the language for the markdown code fence based on file extension.
  ext="${file##*.}"

  case "$ext" in
    c) lang="c" ;;
    h) lang="h" ;;
    py) lang="python" ;;
    rs) lang="rust" ;;
    hs) lang="haskell" ;;
    lean) lang="lean" ;;
    rb) lang="ruby" ;;
    java) lang="java" ;;
    cpp) lang="cpp" ;;
    hpp) lang="cpp" ;;
    *) lang="" ;; # Fallback, should not occur given the find filter.
  esac

  echo "$file"
  echo "\`\`\`$lang"
  cat "$file"
  echo "\`\`\`"
  echo

done
