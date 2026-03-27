alias nvim='NVIM_APPNAME=nvim-lazyvim command nvim'

# Choose neovim distributions by `nvims` command
nvims() {
  # Assumes all configs exist in directories named ~/.config/*
  local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)

  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return

  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) command nvim $@
}

# Create a git worktree and copy project-local files
gwtc() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: gwtc <branch> [path]"
    echo "Creates a git worktree and copies specific files/folders"
    return 1
  fi

  local branch="$1"
  local src_dir
  src_dir="$(git rev-parse --show-toplevel)" || return 1
  local wt_base="${src_dir}-worktree"
  local wt_path="${2:-$wt_base/$branch}"
  mkdir -p "$(dirname "$wt_path")"

  git worktree add "$wt_path" "$branch" 2>/dev/null ||
    git worktree add -b "$branch" "$wt_path" || return 1

  local link_items=(CLAUDE.local.md)
  for item in "${link_items[@]}"; do
    [[ -e "$src_dir/$item" ]] && ln -sf "$src_dir/$item" "$wt_path/$item"
  done

  local copy_items=()
  for item in "${copy_items[@]}"; do
    [[ -e "$src_dir/$item" ]] && cp -r "$src_dir/$item" "$wt_path/"
  done

  echo "Worktree created at $wt_path"
}
