#!/bin/zsh
# 解析 JSON 輸入
json_input=$(cat)
cwd=$(echo "$json_input" | jq -r '.workspace.current_dir // .cwd')
project_dir=$(echo "$json_input" | jq -r '.workspace.project_dir // ""')
model_name=$(echo "$json_input" | jq -r '.model.display_name // .model.id')
version=$(echo "$json_input" | jq -r '.version // "unknown"')

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

# 獲取當前時間
current_time=$(date "+%H:%M")

# 使用 printf 確保顏色正確顯示，並移除尾隨的 $ 或 > 符號
printf "📁 \033[34m%s\033[0m | %s\033[32m%s\033[0m | 🤖 \033[36m%s\033[0m | 🕐 \033[90m%s\033[0m" \
    "$display_path" \
    "$(echo "$git_info" | cut -d' ' -f1) " \
    "$(echo "$git_info" | cut -d' ' -f2-)" \
    "$model_name" \
    "$current_time"