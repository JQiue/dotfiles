if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_color_normal normal
set -g fish_color_command 00BF32
set -g fish_color_keyword 00BF32
set -g fish_color_quote 206676
set -g fish_color_redirection 7CB02C
set -g fish_color_end 8EEB00
set -g fish_color_error 60B9CE
set -g fish_color_param 04819E
set -g fish_color_comment 5C9900
set -g fish_color_match --background=brblue
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_search_match bryellow --background=brblack
set -g fish_color_history_current --bold
set -g fish_color_operator 00a6b2
set -g fish_color_escape 00a6b2
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_option 04819E
set -g fish_color_valid_path --underline=single
set -g fish_color_autosuggestion 64DF85
set -g fish_color_user brgreen
set -g fish_color_host normal
set -g fish_color_host_remote yellow
set -g fish_color_history_current --bold
set -g fish_color_status red
set -g fish_color_cancel --reverse
set -g fish_pager_color_background
set -g fish_pager_color_prefix normal --bold --underline=single
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_pager_color_completion normal
set -g fish_pager_color_description B3A06D
set -g fish_pager_color_selected_background --background=brblack
set -g fish_pager_color_selected_prefix
set -g fish_pager_color_selected_completion
set -g fish_pager_color_selected_description
set -g fish_pager_color_secondary_background
set -g fish_pager_color_secondary_completion
set -g fish_pager_color_secondary_prefix
set -g fish_pager_color_secondary_description

alias sc 'systemctl status'
alias sclist 'systemctl list-units --type=service'
alias scstart 'systemctl start'
alias scstop 'systemctl stop'
alias screstart 'systemctl restart'
alias scenable 'systemctl enable'
alias scdisable 'systemctl disable'
alias sclog 'journalctl -u'
alias sclogclean 'journalctl --vacuum-time=1s -u'
