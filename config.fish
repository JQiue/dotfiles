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

# systemctl shortcut
function sc
    if test (count $argv) -eq 0
        systemctl
        return
    end

    switch $argv[1]
        case s status
            systemctl status $argv[2..]
        case start stop restart reload enable disable
            sudo systemctl $argv
        case on
            sudo systemctl enable --now $argv[2..]
        case off
            sudo systemctl disable --now $argv[2..]
        case log
            journalctl -u $argv[2] -f
        case logs
            journalctl -u $argv[2] -n 100 --no-pager
        case failed
            systemctl --failed
        case list
            systemctl list-units --type=service --all
        case enabled
            systemctl list-unit-files --type=service --state=enabled
        case reload-daemon
            sudo systemctl daemon-reload
        case du
            journalctl --disk-usage
        case clean
            sudo journalctl --rotate
            sudo journalctl --vacuum-time=7d
        case clean-all
            sudo journalctl --rotate
            sudo journalctl --vacuum-time=1s
        case '*'
            systemctl $argv
    end
end