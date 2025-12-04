#!/bin/sh

# Allowed extents:
#   screen
#   first_cmd_output_on_screen
#   last_cmd_output
#   last_visited_cmd_output
#   all
#   selection

# Use first argument as the extent, default to "screen"
EXTENT="${1:-screen}"

case "$EXTENT" in
    screen|first_cmd_output_on_screen|last_cmd_output|last_visited_cmd_output|all|selection)
        ;;
    *)
        printf "Invalid extent: %s\n" "$EXTENT" >&2
        printf "Valid options: screen, first_cmd_output_on_screen, last_cmd_output, last_visited_cmd_output, all, selection\n" >&2
        exit 1
        ;;
esac

# Fetch text from the current kitty window
# --ansi is omitted intentionally → strip escape codes
kitten @ get-text \
    --self \
    --extent="$EXTENT" \
| nvim \
    -c 'setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile' \
    -
