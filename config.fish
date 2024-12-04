if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias sc 'systemctl status'
alias sclist 'systemctl list-units --type=service'
alias scstart 'systemctl start'
alias scstop 'systemctl stop'
alias screstart 'systemctl restart'
alias scenable 'systemctl enable'
alias scdisable 'systemctl disable'
alias sclog 'journalctl -u'
alias sclogclean 'journalctl --vacuum-time=1s -u'
