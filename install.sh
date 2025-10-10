#!/usr/bin/env bash

function Help() {
    cat <<EOF
Usage: install.sh [options ..]

Script to auto-install Dino Slavik's dotfiles. Currently supports only Arch Linux

Examples:
  general configuration                     \`install.sh\`
  hyprland configuration                    \`install.sh -c hyprland\`
  non-regular home directory                \`install.sh -p /mnt/somedrive/user/\`

Options:
  -h, --help                                show help message
  -c, --config                              set configuration to use (default \`general\`)
  -p, --home-dir                            set custom home dir 
                                            (to install only local dotfiles look at \`--only-locals\`)
  --only-locals (NI)                        install only local dotfiles, excluding system-wide ones 
                                            (WARNING: some programs in dotfiles may not work properly)
  --without-general (NI)                    install only config-specific dotfiles
                                            (requires \`-c\` to be set)
                                            (WARNING: some programs in dotfiles may not work properly)
  --do-not-rewrite-existings                prevent files that already exist in your system to be rewriten
  --install-requirements (NI)               install requirements before installing configuration
                                            (Note that you also can install them using `install_requirements.sh`)

*Note that (NI) options not yet implemented and will be added soon

Configurations:
  (default) general                         install only general configs, such as vim, links, ranger etc
  hyprland                                  install hyprland-relative configs

EOF
}

function Print() {
    #if [ $DEBUG -eq 0 ]; then
    #    return 0
    #fi

    1>&2 printf "$@"
}

function create_directory() {
    if [ -d "$1" ]; then
        Print "=> \`$1\` directiory already exists, skipping\n"
    elif [ -e "$1" ]; then
        Print "==]> ERROR: \`$1\` is a file, aborting\n"
        exit
    else
        Print "=> Creating \`$1\` directiory\n"
        mkdir $1
    fi
}

function copy_file() {
    if [[ ! -e "$1" || -d "$1" ]]; then
        Print "==]> ERROR: Can't copy non existing file or directory (check \`copy_dir\`)\n     Note that it repo's fault, so try to reclone it or install previous version from github releases (if there is any). If it isn't worked please create issue on github or contact me (Dino Slavik).\n"
        Print "     Tried to copy \`$1\`\n"
        exit
    fi
    if [ -e "$2" ]; then
        Print "=> Copying \`$1\` to \`$2\`\n"
        if [ $ISREWRITINGEXISTINGS ]; then
            Print "==> \`$2\` target file already exists, overwriting\n"
            cp $1 $2
        else
            Print "==> \`$2\` target file already exists, skipping\n"
        fi
    elif [ -d "$2" ]; then
        Print "==]> ERROR: target \`$HOMEDIR/$2\` is a directory, aborting\n"
        exit
    else
        Print "=> Copying \`$1\` to \`$2\`\n"
        cp $1 $2
    fi
}

function soft_link() {
    if [[ ! -e "$1" && ! -d "$1" && ! -L "$1" ]]; then
        Print "==]> ERROR: Can't link non existing file or non existing directory\n     NOTE that it repo's or my fault, so try to reclone it or install previous version from github releases (if there is any). \n     If it isn't worked please create issue on github (DinoSlavik/dotfiles) or contact me (Dino Slavik).\n"
        Print "     Tried to link \`$1\`\n"
        Print "     To \`$2\`\n"
        exit
    fi
    if [[ -e "$2" || -d "$2" || -L "$2" ]]; then
        Print "=> Soft Linking \`$1\` to \`$2\`\n"
        if [ $ISREWRITINGEXISTINGS ]; then
            Print "==> \`$2\` target already exists, overwriting \n"
            ln -sf $1 $2
        else
            Print "==> \`$2\` target already exists, skipping\n"
        fi
    else
        Print "=> Soft Linking \`$1\` to \`$2\`\n"
        ln -s $1 $2
    fi
}

function general_install() {
    Print "====[ Installing General Configuration ]====\n"
    # Directories creation
    Print "==]> Creating directories\n"
    create_directory "$HOMEDIR/Desktop"
    create_directory "$HOMEDIR/Documents"
    create_directory "$HOMEDIR/Downloads"
    create_directory "$HOMEDIR/Music"
    create_directory "$HOMEDIR/Pictures"
    create_directory "$HOMEDIR/Public"
    create_directory "$HOMEDIR/Temp"
    create_directory "$HOMEDIR/Videos"
    # Dotdirectories
    create_directory "$HOMEDIR/.config"
    create_directory "$HOMEDIR/.config/kitty"
    create_directory "$HOMEDIR/.config/kitty/custom-themes"
    create_directory "$HOMEDIR/.config/MangoHud"
    create_directory "$HOMEDIR/.links"
    create_directory "$HOMEDIR/.vim"
    create_directory "$HOMEDIR/.vim/autoload"
    create_directory "$HOMEDIR/.vim/backup"
    create_directory "$HOMEDIR/.vim/colors"
    create_directory "$HOMEDIR/.vim/plugged"
    create_directory "$HOMEDIR/.oh-my-zsh"

    # Configs
    Print "\n==]> Coping .confg files\n"
    ## User Dirs
    Print "====]> Coping user dirs configs\n"
    copy_file "$(pwd)/general/.config/user-dirs.dirs" "$HOMEDIR/.config/user-dirs.dirs"
    copy_file "$(pwd)/general/.config/user-dirs.locale" "$HOMEDIR/.config/user-dirs.locale"

    ## Kitty
    Print "\n====]> Coping Kitty configs\n"
    copy_file "$(pwd)/general/.config/kitty/kitty.conf" "$HOMEDIR/.config/kitty/kitty.conf"
    copy_file "$(pwd)/general/.config/kitty/custom-themes/Afterglow.custom.conf" "$HOMEDIR/.config/kitty/custom-themes/Afterglow.custom.conf"
    soft_link "$(pwd)/general/.config/kitty/custom-themes/Afterglow.custom.conf" "$HOMEDIR/.config/kitty/theme.conf"

    ## MangoHud
    Print "\n====]> Coping MangoHud config\n"
    copy_file "$(pwd)/general/.config/MangoHud/MangoHud.conf" "$HOMEDIR/.config/MangoHud/MangoHud.conf"

    # Links


    # Vim
    Print "\n==]> Configuring Vim\n"
    copy_file "$(pwd)/general/.vimrc" "$HOMEDIR/.vimrc"
    Print "=> Istalling Plug\n"
    curl -fLo "$HOMEDIR/.vim/autoload/plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    Print "=> Installing Vim plugins\n"
    vim -c "PlugInstall" -c "qa!"
    copy_file "$(pwd)/general/.vim/colors/molokai.vim" "$HOMEDIR/.vim/colors/molokai.vim"

    # zsh
    copy_file "$(pwd)/general/.zshrc" "$HOMEDIR/.zshrc"
    copy_file "$(pwd)/general/.zsh_aliases" "$HOMEDIR/.zsh_aliases"
    # bash
    copy_file "$(pwd)/general/.bashrc" "$HOMEDIR/.bashrc"
    soft_link "$(pwd)/general/.zsh_aliases" "$HOMEDIR/.bash_aliases"

    Print "\n==]> Done!\n"
}

function hyprland_install() {
    general_install
    Print "\n\n====[ Installing Hyprland Configuration ]====\n"

    Print "\n==]> Done!\n"
}

function args() {
    local options=$(getopt -o hc:p: --long help,config:,home-dir:,do-not-rewrite-existings -- "$@")
    eval set -- "$options"

    while true; do 
        case "$1" in
            -h | --help)
                Help
                exit
                ;;
            -c | --config)
                shift;
                CONFIGURATION=$1
                ;;
            -p | --home-dir)
                shift;
                # TODO: Check is it safe, maybe it should use `realpath` command
                # But `realpath` raises error saying "..." is directiory
                HOMEDIR="$(cd -P -- $1 && pwd)"
                ;;
            --do-not-rewrite-existings)
                ISREWRITINGEXISTINGS=0
                shift
                ;;
            --)
                shift
                COMMAND=${@:2}
                break;;
        esac
        shift
    done

}

CONFIGURATION="general"
HOMEDIR="$HOME"
ISREWRITINGEXISTINGS=1

args $0 "$@"


case "$CONFIGURATION" in
    general)
        general_install
        exit
        ;;
    hyprland)
        hyprland_install
        exit
        ;;
esac

