#!/bin/zsh
# 解析 JSON 輸入
json_input=$(cat)
cwd=$(echo "$json_input" | jq -r '.workspace.current_dir // .cwd')
project_dir=$(echo "$json_input" | jq -r '.workspace.project_dir // ""')
model_name=$(echo "$json_input" | jq -r '.model.display_name // .model.id')
version=$(echo "$json_input" | jq -r '.version // "unknown"')
effort=$(jq -r '.effortLevel // empty' "$HOME/.claude/settings.json" 2>/dev/null)

# Session context
total_duration_ms=$(echo "$json_input" | jq -r '.cost.total_duration_ms // empty')
total_cost=$(echo "$json_input" | jq -r '.cost.total_cost_usd // empty')
lines_added=$(echo "$json_input" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$json_input" | jq -r '.cost.total_lines_removed // empty')
ctx_used_pct=$(echo "$json_input" | jq -r '.context_window.used_percentage // empty')

# 獲取相對路徑顯示
if [[ -n "$project_dir" && "$cwd" == "$project_dir"* ]]; then
    rel_path=${cwd#$project_dir}
    [[ -z "$rel_path" ]] && rel_path="/"
    display_path="$(basename "$project_dir")$rel_path"
else
    display_path=$(basename "$cwd")
fi

# 獲取 Git 分支和狀態
if [[ -d "$cwd/.git" ]] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(cd "$cwd" && git branch --show-current 2>/dev/null)
    [[ -z "$git_branch" ]] && git_branch=$(cd "$cwd" && git describe --contains --all HEAD 2>/dev/null | sed 's/.*\///')
    [[ -z "$git_branch" ]] && git_branch="detached"
    
    # 檢查 Git 狀態
    git_status=$(cd "$cwd" && git status --porcelain 2>/dev/null)
    if [[ -n "$git_status" ]]; then
        git_indicator="*"
    else
        git_indicator=""
    fi
    git_info="⎇ $git_branch$git_indicator"
else
    git_info="no-git"
fi

# Build progress bar: filled/empty circles with color
# Usage: build_bar <percentage_int> <color_code>
build_bar() {
    local pct=$1 color=$2
    local total=10
    local filled=$(( (pct + 5) / 10 ))
    (( filled > total )) && filled=$total
    (( filled < 0 )) && filled=0
    local empty=$(( total - filled ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="●"; done
    for ((i=0; i<empty; i++)); do bar+="○"; done
    printf "\033[%sm%s\033[0m" "$color" "$bar"
}

# Format reset time from unix epoch
format_reset() {
    local epoch=$1
    if [[ -z "$epoch" || "$epoch" == "null" ]]; then
        echo ""
        return
    fi
    # If resets within 24h, show time only; otherwise show date + time
    local now=$(date +%s)
    local diff=$(( epoch - now ))
    if (( diff < 86400 )); then
        date -r "$epoch" "+%-I:%M%P" 2>/dev/null || date -d "@$epoch" "+%-I:%M%P" 2>/dev/null
    else
        date -r "$epoch" "+%b %-d, %-I:%M%P" 2>/dev/null || date -d "@$epoch" "+%b %-d, %-I:%M%P" 2>/dev/null
    fi
}

# Format milliseconds to human-readable duration
format_duration() {
    local ms=$1
    if [[ -z "$ms" || "$ms" == "null" ]]; then
        echo ""
        return
    fi
    local total_sec=$(( ms / 1000 ))
    local hours=$(( total_sec / 3600 ))
    local mins=$(( (total_sec % 3600) / 60 ))
    local secs=$(( total_sec % 60 ))
    if (( hours > 0 )); then
        printf "%dh %dm" "$hours" "$mins"
    elif (( mins > 0 )); then
        printf "%dm %ds" "$mins" "$secs"
    else
        printf "%ds" "$secs"
    fi
}

# Build session info lines
session_lines=""

# Session stats: duration, cost, lines changed
session_stats=""
if [[ -n "$total_duration_ms" ]]; then
    duration_str=$(format_duration "$total_duration_ms")
    session_stats="⏱ \033[33m${duration_str}\033[0m"
fi
if [[ -n "$total_cost" && "$total_cost" != "null" ]]; then
    cost_formatted=$(printf '$%.2f' "$total_cost")
    [[ -n "$session_stats" ]] && session_stats+="  "
    session_stats+="\033[35m${cost_formatted}\033[0m"
fi
if [[ -n "$lines_added" || -n "$lines_removed" ]]; then
    la=${lines_added:-0}
    lr=${lines_removed:-0}
    if (( la > 0 || lr > 0 )); then
        [[ -n "$session_stats" ]] && session_stats+="  "
        session_stats+="\033[32m+${la}\033[0m/\033[31m-${lr}\033[0m"
    fi
fi
[[ -n "$session_stats" ]] && session_lines="\nsession  ${session_stats}"

# Context window usage bar
if [[ -n "$ctx_used_pct" ]]; then
    ctx_int=${ctx_used_pct%.*}
    if (( ctx_int >= 80 )); then
        ctx_color="31"  # red
    elif (( ctx_int >= 50 )); then
        ctx_color="33"  # yellow
    else
        ctx_color="32"  # green
    fi
    ctx_bar=$(build_bar "$ctx_int" "$ctx_color")
    session_lines="${session_lines}\ncontext  ${ctx_bar} ${ctx_int}%"
fi

# Rate limit info
five_hour_pct=$(echo "$json_input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$json_input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$json_input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$json_input" | jq -r '.rate_limits.seven_day.resets_at // empty')

rate_lines=""
if [[ -n "$five_hour_pct" ]]; then
    five_int=${five_hour_pct%.*}
    five_bar=$(build_bar "$five_int" "32")  # green
    five_reset=$(format_reset "$five_hour_reset")
    reset_part=""
    [[ -n "$five_reset" ]] && reset_part="  ↻ ${five_reset}"
    rate_lines="\ncurrent  ${five_bar} ${five_int}%${reset_part}"
fi
if [[ -n "$seven_day_pct" ]]; then
    seven_int=${seven_day_pct%.*}
    seven_bar=$(build_bar "$seven_int" "33")  # yellow
    seven_reset=$(format_reset "$seven_day_reset")
    reset_part=""
    [[ -n "$seven_reset" ]] && reset_part="  ↻ ${seven_reset}"
    rate_lines="${rate_lines}\nweekly   ${seven_bar} ${seven_int}%${reset_part}"
fi

# Current time
current_time=$(date "+%H:%M")

# Output
printf "📁 \033[34m%s\033[0m | %s\033[32m%s\033[0m | 🤖 \033[36m%s\033[0m | 🕐 \033[90m%s\033[0m%b" \
    "$display_path" \
    "$(echo "$git_info" | cut -d' ' -f1) " \
    "$(echo "$git_info" | cut -d' ' -f2-)" \
    "$model_name${effort:+ ($effort)}" \
    "$current_time" \
    "${session_lines}${rate_lines}"