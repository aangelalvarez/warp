# ─────────────────────────────────────────────────────────────────────────────
# ✅ Shell Suggestions:
#   - zsh-autosuggestions → brew install zsh-autosuggestions
# ─────────────────────────────────────────────────────────────────────────────

# aliases
alias backup-drive="~/programming/scripts/backup_drive.sh"
alias backup-usb-drive="~/programming/scripts/backup_usb_drive.sh"
alias move-photos="~/programming/scripts/move_photos.sh"
alias mirror-phone="~/programming/software/scrcpy-macos-aarch64-v3.2/scrcpy"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# ----- For iTerm2 -----

parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[⎇ \1]/p'
}

# Git additions
function git_additions() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local additions
        additions=$(git diff --shortstat | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+')
        if [ -n "$additions" ]; then
            echo "+${additions}"
        fi
    fi
}

# Git deletions
function git_deletions() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local deletions
        deletions=$(git diff --shortstat | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+')
        if [ -n "$deletions" ]; then
            echo "-${deletions}"
        fi
    fi
}

# Show current conda or venv environment
function show_env() {
  if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    echo "${COLOR_VENV}(${CONDA_DEFAULT_ENV})"
  elif [[ -n "$VIRTUAL_ENV" ]]; then
    echo "${COLOR_VENV}($(basename "$VIRTUAL_ENV"))"
  fi
}

# Track command duration
function preexec() {
  CMD_TIMER_START=$EPOCHREALTIME
}

function precmd() {
  if [[ -n "$CMD_TIMER_START" ]]; then
    local elapsed
    elapsed=$(printf "%.1fs" "$(echo "$EPOCHREALTIME - $CMD_TIMER_START" | bc)")
    export LAST_CMD_DURATION=$elapsed
  else
    export LAST_CMD_DURATION=""
  fi
}


# # Node.js → shows if .js/.ts or package.json or bun.lockb exists
# function show_node() {
#   if command -v node &>/dev/null && \
#      ls *.js *.ts package.json bun.lockb 2>/dev/null | grep -q .; then
#     local version=$(node -v)
#     echo "${COLOR_NODE}[node:${version}] "
#   fi
# }

# # Python → shows if .py or pyproject.toml or requirements.txt or Pipfile exists
# function show_python() {
#   if command -v python3 &>/dev/null && \
#      ls *.py pyproject.toml requirements.txt Pipfile 2>/dev/null | grep -q .; then
#     local version=$(python3 --version 2>&1 | awk '{print $2}')
#     echo "${COLOR_PYTHON}[py:${version}] "
#   fi
# }

# # Go → shows if .go or go.mod or go.sum exists
# function show_go() {
#   if command -v go &>/dev/null && \
#      ls *.go go.mod go.sum 2>/dev/null | grep -q .; then
#     local version=$(go version | awk '{print $3}' | sed 's/go//')
#     echo "${COLOR_GO}[go:${version}] "
#   fi
# }

# # Java → shows if .java or pom.xml or build.gradle exists
# function show_java() {
#   if command -v java &>/dev/null && \
#      ls *.java pom.xml build.gradle 2>/dev/null | grep -q .; then
#     local version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
#     echo "${COLOR_JAVA}[java:${version}] "
#   fi
# }

# # C++ → shows if .cpp/.cc/.cxx or CMakeLists.txt or Makefile exists
# function show_cpp() {
#   if command -v g++ &>/dev/null && \
#      ls *.{cpp,cc,cxx} CMakeLists.txt Makefile 2>/dev/null | grep -q .; then
#     local version=$(g++ --version | head -n 1 | sed -E 's/.* ([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
#     echo "${COLOR_CPP}[g++:${version}] "
#   elif command -v clang++ &>/dev/null && \
#        ls *.{cpp,cc,cxx} CMakeLists.txt Makefile 2>/dev/null | grep -q .; then
#     local version=$(clang++ --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')
#     echo "${COLOR_CPP}[clang++:${version}] "
#   fi
# }



# ──────────────────────────────────────
# Pastel Color Palette (per section)

COLOR_DEF='%f'
COLOR_USR='%F{#caffbf}'          # pastel green (user)
COLOR_ADDITIONS='%F{#caffbf}'   # pastel green (git +)
COLOR_DELETIONS='%F{#ffadad}'   # pastel red (git -)
COLOR_DIR='%F{#a0c4ff}'         # soft blue
COLOR_GIT='%F{#9bf6ff}'         # cyan
COLOR_VENV='%F{#bdb2ff}'        # lilac
COLOR_CLOCK='%F{#accbd9}'       # peach
COLOR_NODE='%F{#caffbf}'        # pastel green (Node.js)
COLOR_PYTHON='%F{#9ec6f3}'      # cyan
COLOR_GO='%F{#9bf6ff}'          # cyan
COLOR_JAVA='%F{#ffc6c6}'        # pastel red-pink
COLOR_CPP='%F{#b0d6f8}'         # pastel icy blue

NEWLINE=$'\n'


# Prompt setup
setopt PROMPT_SUBST

export PROMPT='%B$(show_env)${COLOR_USR}%n@%m: ${COLOR_DIR}%999~ ${COLOR_GIT}$(parse_git_branch) ${COLOR_ADDITIONS}$(git_additions)${COLOR_DELETIONS}$(git_deletions) ${COLOR_CLOCK}⏱ $LAST_CMD_DURATION${COLOR_DEF}${NEWLINE}» %b'


# show the language version
#export PROMPT='%B$(show_env)$(show_node)$(show_python)$(show_go)$(show_java)$(show_cpp)${COLOR_USR}%n@%m: ${COLOR_DIR}%999~ ${COLOR_GIT}$(parse_git_branch) ${COLOR_ADDITIONS}$(git_additions)${COLOR_DELETIONS}$(git_deletions) ${COLOR_CLOCK}⏱ $LAST_CMD_DURATION${COLOR_DEF}${NEWLINE}» %b'

# bun completions
[ -s "/Users/angel/.bun/_bun" ] && source "/Users/angel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# arrow key completion
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '\t' end-of-line

# autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# other paths
export PATH=$PATH:/Users/angel/.spicetify
[ -f "/Users/angel/.ghcup/env" ] && . "/Users/angel/.ghcup/env"
export PATH="$PATH:/Users/angel/.lmstudio/bin"

# scripts
function spotify() {
    cd ~/programming/software || return
    conda activate spotify
    python3 spotify.py
}

function xpotify() {
    conda deactivate
}

function storage() {
    df -h /
}

spicetifyfull() {
  spicetify update && (spicetify backup apply || spicetify restore backup apply) && open -a Spotify
}

# Countdown with sound + macOS notification
countdown() {
  if [ -z "$1" ]; then
    echo "Usage: countdown <seconds> [message]"; return 1
  fi

  local secs="$1"
  shift
  local msg="${*:-Time's up!}"

  # live MM:SS display
  while [ "$secs" -gt 0 ]; do
    printf "\r%02d:%02d" $((secs/60)) $((secs%60))
    sleep 1
    : $((secs--))
  done

  # final line + terminal bell
  echo -e "\r⏰ $msg        \a"

  # macOS notification (if available)
  if command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"$msg\" with title \"Countdown\" sound name \"Glass\""
  fi

  # sound: prefer afplay, else say (macOS)
  if command -v afplay >/dev/null 2>&1; then
    # play a system sound
    for i in {1..3}; do
      afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
      sleep 1
    done
    wait
  elif command -v say >/dev/null 2>&1; then
    say "$msg" >/dev/null 2>&1 &
  fi
}

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
