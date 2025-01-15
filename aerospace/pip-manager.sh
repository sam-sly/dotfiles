#!/usr/bin/env sh

# Default workspace to $AEROSPACE_FOCUSED_WORKSPACE if not provided
ws=${1:-$AEROSPACE_FOCUSED_WORKSPACE}

# Get all windows and workspaces
IFS='
'
all_wins=$(aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}|%{monitor-id}|%{workspace}')
all_ws=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

# List of possible window titles
pip_titles="Picture-in-picture|Picture-in-Picture|Picture in Picture|Picture in picture"

# Function to find matching PIP windows
find_pip_windows() {
  echo "$all_wins" | grep -E "$pip_titles" | sed '/^\s*$/d' # Remove empty lines
}

pip_wins=$(find_pip_windows)

# Get target monitor ID for the specified workspace
target_mon=$(echo "$all_ws" | grep "^$ws|" | cut -d'|' -f2 | xargs)

# Function to move a window to the target workspace
move_win() {
  win="$1"
  [ -n "$win" ] || return 0

  win_mon=$(echo "$win" | cut -d'|' -f4 | xargs)
  win_id=$(echo "$win" | cut -d'|' -f1 | xargs)
  win_ws=$(echo "$win" | cut -d'|' -f5 | xargs)

  # Skip if the monitor is already the target monitor or if the workspace matches
  [ "$target_mon" != "$win_mon" ] && return 0
  [ "$ws" = "$win_ws" ] && return 0

  aerospace move-node-to-workspace --window-id "$win_id" "$ws"
}

# Process each PIP window found
echo "$pip_wins" | while IFS= read -r win; do
  move_win "$win"
done
