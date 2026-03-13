{pkgs, ...}:
let
  commandPaneZdotdir = pkgs.writeTextDir ".zshrc" ''
    setopt promptsubst
    setopt hist_ignore_all_dups
    setopt hist_reduce_blanks
    setopt hist_save_no_dups
    setopt inc_append_history
    setopt auto_menu
    setopt complete_in_word
    bindkey -e

    self_pane="''${TMUX_PANE:-$(tmux display-message -p '#{pane_id}')}"
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/tmux-command-pane"
    history_file="''${state_dir}/history"

    mkdir -p "''${state_dir}"
    touch "''${history_file}"
    HISTFILE="''${history_file}"
    HISTSIZE=10000
    SAVEHIST=10000
    fc -R "''${HISTFILE}" 2>/dev/null || true

    zstyle ':completion:*' menu select
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path "''${state_dir}/zcompcache"
    autoload -Uz compinit
    compinit -d "''${state_dir}/zcompdump"
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

    find_target_pane() {
      local window_id current_top

      window_id="$(tmux display-message -p -t "$self_pane" '#{window_id}')"
      current_top="$(tmux display-message -p -t "$self_pane" '#{pane_top}')"

      tmux list-panes -t "$window_id" -F '#{pane_id} #{pane_bottom}' \
        | awk -v top="$current_top" '$2 < top && $2 > max { max = $2; pane = $1 } END { print pane }'
    }

    format_prompt_path() {
      local path="$1"

      if [[ -n "''${HOME:-}" && "$path" == "$HOME"* ]]; then
        printf '~%s' "''${path#"$HOME"}"
      else
        printf '%s' "$path"
      fi
    }

    current_prompt_path() {
      local target_pane

      target_pane="$(find_target_pane || true)"
      if [[ -n "$target_pane" ]]; then
        tmux display-message -p -t "$target_pane" '#{pane_current_path}'
      else
        tmux display-message -p -t "$self_pane" '#{pane_current_path}'
      fi
    }

    current_target_hint() {
      local target_pane

      target_pane="$(find_target_pane || true)"
      if [[ -n "$target_pane" ]]; then
        tmux display-message -p -t "$target_pane" '#{window_index}.#{pane_index}'
      else
        printf 'no-target'
      fi
    }

    sync_target_context() {
      local target_path

      target_path="$(current_prompt_path)"
      if [[ -n "$target_path" && -d "$target_path" && "$PWD" != "$target_path" ]]; then
        builtin cd -q -- "$target_path" 2>/dev/null || true
      fi
    }

    refresh_prompt() {
      local target_path target_hint

      target_path="$(current_prompt_path)"
      target_hint="$(current_target_hint)"
      sync_target_context
      PROMPT="$(format_prompt_path "$target_path")> "

      if [[ "$target_hint" == "no-target" ]]; then
        RPROMPT='[no target]'
      else
        RPROMPT="[send ''${target_hint}]"
      fi
    }

    persist_history() {
      fc -W "''${HISTFILE}" 2>/dev/null || true
    }

    tmux_command_pane_complete() {
      refresh_prompt
      zle complete-word
    }

    tmux_command_pane_accept_line() {
      local line target_pane

      line="$BUFFER"
      BUFFER=""
      CURSOR=0
      zle -I

      [[ -n "$line" ]] || {
        zle reset-prompt
        return 0
      }

      print -sr -- "$line"
      persist_history

      if [[ "$line" == "clear" ]]; then
        tmux clear-history -t "$self_pane" 2>/dev/null || true
        zle clear-screen
        return 0
      fi

      if [[ "$line" == "exit" ]]; then
        tmux kill-window -t "$(tmux display-message -p -t "$self_pane" '#{window_id}')"
        return 0
      fi

      target_pane="$(find_target_pane || true)"
      if [[ -z "$target_pane" ]]; then
        zle -M "No pane above to receive command."
        zle reset-prompt
        return 0
      fi

      tmux send-keys -t "$target_pane" -l -- "$line"
      tmux send-keys -t "$target_pane" C-m
      zle reset-prompt
    }

    tmux_command_pane_line_init() {
      refresh_prompt
      zle reset-prompt
    }

    zle -N accept-line tmux_command_pane_accept_line
    zle -N zle-line-init tmux_command_pane_line_init
    zle -N tmux_command_pane_complete
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search

    bindkey '^I' tmux_command_pane_complete
    bindkey '^[[A' up-line-or-beginning-search
    bindkey '^[[B' down-line-or-beginning-search
    bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
    bindkey "$terminfo[kcud1]" down-line-or-beginning-search

    refresh_prompt
  '';
  commandPane = pkgs.writeShellApplication {
    name = "tmux-command-pane";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      tmux
      zsh
    ];
    text = ''
      exec env ZDOTDIR="${commandPaneZdotdir}" ${pkgs.zsh}/bin/zsh -di
    '';
  };
  toggleModalPane = pkgs.writeShellApplication {
    name = "tmux-toggle-modal-pane";
    runtimeInputs = with pkgs; [
      coreutils
      tmux
    ];
    text = ''
      set -euo pipefail

      if [[ "''${1:-}" == "client" ]]; then
        modal_session_name="''${2:?missing modal session name}"
        modal_start_path="''${3:-''${HOME:-/}}"

        if [[ ! -d "''${modal_start_path}" ]]; then
          modal_start_path="''${HOME:-/}"
        fi

        if tmux has-session -t "=''${modal_session_name}" 2>/dev/null; then
          tmux kill-session -t "=$modal_session_name" 2>/dev/null || true
        fi

        tmux new-session -d -s "$modal_session_name" -n scratch -c "$modal_start_path" "keel screen"
        tmux set-option -t "=''${modal_session_name}" status off
        exec tmux attach-session -t "=''${modal_session_name}"
      fi

      popup_client="''${TMUX_MODAL_CLIENT:-''${1:-$(tmux display-message -p '#{client_tty}')}}"
      current_session="''${TMUX_MODAL_SESSION:-''${2:-$(tmux display-message -p '#{session_id}')}}"
      current_path="''${TMUX_MODAL_PATH:-''${3:-$(tmux display-message -p '#{pane_current_path}')}}"
      current_session_name="$(tmux display-message -p -t "$current_session" '#{session_name}' 2>/dev/null || true)"
      if [[ -z "''${current_session_name}" ]]; then
        current_session_name="$(tmux display-message -p '#{session_name}' 2>/dev/null || true)"
      fi
      modal_width="$(tmux show-option -gqv @modal_width || true)"
      modal_height="$(tmux show-option -gqv @modal_height || true)"

      if [[ -z "''${popup_client}" ]]; then
        printf 'tmux-toggle-modal-pane: no target client\n' >&2
        exit 1
      fi

      if [[ -z "''${modal_width}" ]]; then
        modal_width='80%'
      fi

      if [[ -z "''${modal_height}" ]]; then
        modal_height='70%'
      fi

      if [[ ! -d "''${current_path}" ]]; then
        current_path="''${HOME:-/}"
      fi

      if [[ "''${current_session_name}" == __modal__* ]]; then
        modal_session_name="''${current_session_name}"
      else
        modal_session_name="__modal__''${current_session#\$}"
      fi

      if [[ -n "$(tmux display-message -p -c "$popup_client" '#{popup_height}' 2>/dev/null || true)" ]]; then
        tmux display-popup -C -c "$popup_client"
        exit 0
      fi

      if [[ "$current_session_name" == __modal__* ]]; then
        # If this command is ever invoked from inside a modal session directly,
        # no-op and rely on the key binding's detach path to close it.
        exit 0
      fi

      popup_title="scratch ''${current_session_name}"
      popup_command="$0 client $(printf '%q' "$modal_session_name") $(printf '%q' "$current_path")"

      tmux display-popup \
        -c "$popup_client" \
        -d "$current_path" \
        -w "$modal_width" \
        -h "$modal_height" \
        -x C \
        -y C \
        -T "$popup_title" \
        "$popup_command"
    '';
  };
in {
  programs.tmux = {
    enable = true;

    escapeTime = 0;
    historyLimit = 4096;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
    ];

    extraConfig = ''
      # Set the default terminal terminfo
      set -g default-terminal "tmux-256color"
      # Tell Tmux that outside terminal supports true color
      set-option -sa terminal-features ',xterm-kitty:Tc'

      # Copy using mouse with copy-mode
      set -g mouse on

      # Window status bar
      set-option -g status-position bottom
      set-option -g window-status-format '#{?window_activity_flag,#[fg=colour51,bold]![default] ,}#I:#W#{?window_flags,#{window_flags},}'
      set-option -g window-status-current-format '#[bold]#I:#W#{?window_flags,#{window_flags},}'
      set-option -g window-status-activity-style 'fg=colour51,bold'

      # Navigate history with vi keys
      set -g status-keys vi
      set -g mode-keys   vi

      # Copy to primary clipboard
      set -g @yank_selection 'primary'

      # Set the window size to the smallest client
      # - useful for remote pairing sessions
      set-window-option -g window-size smallest
      set-window-option -g monitor-activity on

      # Create new windows from the current pane's working directory.
      bind-key c new-window -c "#{pane_current_path}"

      # New windows start as a top/bottom stack, with a 5-line command pane below.
      set-hook -g after-new-session 'if-shell -F "#{&&:#{==:#{window_panes},1},#{==:#{m:__modal__*,#{session_name}},0}}" "split-window -d -v -f -l 5 -c \"#{session_path}\" \"${commandPane}/bin/tmux-command-pane\"; select-pane -D"'
      set-hook -g after-new-window  'if-shell -F "#{&&:#{==:#{window_panes},1},#{==:#{m:__modal__*,#{session_name}},0}}" "split-window -d -v -f -l 5 -c \"#{pane_current_path}\" \"${commandPane}/bin/tmux-command-pane\"; select-pane -D"'

      # Stateful scratch popup toggle.
      set -g @modal_width '80%'
      set -g @modal_height '70%'
      bind-key t if-shell -F '#{m:__modal__*,#{session_name}}' 'detach-client' 'run-shell "TMUX_MODAL_CLIENT=#{q:client_tty} TMUX_MODAL_SESSION=#{q:session_id} TMUX_MODAL_PATH=#{q:pane_current_path} ${toggleModalPane}/bin/tmux-toggle-modal-pane"'
      bind-key s choose-tree -Zs -f '#{==:#{m:__modal__*,#{session_name}},0}' -F '#{?session_activity_flag,#[fg=colour51,bold]![default] ,}#{session_name}: #{session_windows} windows#{?session_grouped, (group #{session_group}: #{session_group_list}),}#{?session_attached, (attached),}'
    '';
  };
}
