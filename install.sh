#!/bin/sh

launch_date="$(date +'%F_%T')"
usage=$(cat <<EOF
    Usage:
       ./install.sh [overwrite|save] [doomemacs|minimalemacs|noemacs]
EOF
)

if [ "$#" -ne 2 ]; then
    echo "$usage"
    exit 1
fi

save_choice="$1"
emacs_choice="$2"

create_copy_save() {
    dir="$1"
    confdir="$2"
    mkdir -p "$dir"
    if test ${save_choice} = "save"; then
        # Create timestamped dir for old configuration
        mkdir -p "$launch_date"
        cp -r "$dir/$confdir" "$launch_date/$confdir"
    fi
    cp -r "$confdir" "$dir/$confdir"
}

emacs_install() {
    if test ${save_choice} = "save"; then
        mkdir -p "$launch_date"
        if test ${emacs_choice} = "minimalemacs"; then
            mv "$HOME/.emacs" "$launch_date/.emacs"
        elif test ${emacs_choice} = "doomemacs"; then
            mv "$HOME/.doom.d" "$launch_date/.doom.d"
        fi
    else
        if test ${emacs_choice} = "minimalemacs"; then
            rm -rf "$HOME/.emacs"
        elif test ${emacs_choice} = "doomemacs"; then
            rm -rf "$HOME/.doom.d"
        fi
    fi

    if test ${emacs_choice} = "minimalemacs"; then
        git clone https://github.com/n1tsu/minimal-emacs.git "$HOME/.emacs"
    elif test ${emacs_choice} = "doomemacs"; then
        git clone https://github.com/n1tsu/doom-config.git "$HOME/.doom.d"
        $HOME/.emacs/bin/doom update
    else
        return
    fi
}

# Copy wallpapers
create_copy_save "$HOME/Pictures/" "Wallpapers"

# Copy polybar config
create_copy_save "$HOME/.config" "polybar"

# Copy alacritty config
create_copy_save "$HOME/.config" "alacritty"

# Copy i3 config
create_copy_save "$HOME/.config" "i3"

# Copy dunst config
create_copy_save "$HOME/.config" "dunst"

# Copy Xmodmap file
cp .Xmodmap "$HOME/.Xmodmap"

# Modify .zshrc
sed -i 's/ZSH_THEME=\"[a-zA-Z0-9]+\"/ZSH_THEME=\"lambda\"/g' "$HOME/.zshrc"

# Create theme file
echo "black" > "$HOME/.config/.theme"

# copy doom emacs config
emacs_install
