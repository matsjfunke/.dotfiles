#!/usr/bin/env bash
# Arc-style "focus-if-open" for Chrome.
# Scans every Chrome tab; if one matches $1, switch to it. Otherwise open $2.
#
# Usage: chrome-goto.sh <match-substring> <url-to-open>
#   match-substring : substring tested against each tab's URL (e.g. "github.com/pulls")
#   url-to-open     : full URL to open when no tab matches (defaults to match-substring)
#
# Triggered from karabiner.json (Option+1..9, scoped to Chrome).

set -euo pipefail

match="${1:?need a match substring}"
url="${2:-$1}"

osascript - "$match" "$url" <<'APPLESCRIPT'
on run argv
    set matchStr to item 1 of argv
    set openURL to item 2 of argv
    tell application "Google Chrome"
        activate
        repeat with w in (every window)
            set i to 0
            repeat with t in (every tab of w)
                set i to i + 1
                if (URL of t) contains matchStr then
                    set active tab index of w to i
                    set index of w to 1
                    return
                end if
            end repeat
        end repeat
        -- No matching tab: open it.
        if (count of windows) is 0 then
            make new window
            set URL of active tab of front window to openURL
        else
            tell front window to make new tab with properties {URL:openURL}
        end if
    end tell
end run
APPLESCRIPT
