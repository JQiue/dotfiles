#!/bin/bash
link_file() {
    local source=$1
    local destination=$2
    # 如果目标文件存在
    if [ -f "$destination" ]; then
        # 创建备份
        mv "$destination" "$destination.backup"
    fi
    # 创建符号链接
    ln -s "$source" "$destination"
}

link_file ~/dotfiles/.gitconfig ~/.gitconfig
link_file ~/dotfiles/config.fish ~/.config/fish/config.fish
