#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "      ./theme.sh [white|black|swap]"
    exit 1
fi

alacritty_dir="$HOME/.config/alacritty"
wallpaper_dir="$HOME/Pictures/Wallpapers"
theme_file="$HOME/.config/.theme"
polybar_dir="$HOME/.config/polybar/colorblocks/scripts"

black_theme() {
    # Change polybar
    sh "${polybar_dir}/colors-dark.sh" --gray
    # Change wallpaper
    ln -fs "${wallpaper_dir}/alien.png" "${wallpaper_dir}/wallpaper.png"
    feh --bg-fill "${wallpaper_dir}/wallpaper.png"
    # Change emacs config
    echo "black" > ${theme_file}
    # Change terminal theme
    ln -fs "${alacritty_dir}/black.yml" "${alacritty_dir}/alacritty.yml"
}

white_theme() {
    # Change polybar
    sh "${polybar_dir}/colors-light.sh" --gray
    # Change wallpaper
    ln -fs "${wallpaper_dir}/polygon.jpg" "${wallpaper_dir}/wallpaper.png"
    feh --bg-fill "${wallpaper_dir}/wallpaper.png"
    # Change emacs config
    echo "white" > ${theme_file}
    # Change terminal theme
    ln -fs "${alacritty_dir}/white.yml" "${alacritty_dir}/alacritty.yml"
}

swap_theme() {
    theme=`cat ${theme_file} | xargs`
    if test $theme = "white"; then
        black_theme
    else
        white_theme
    fi
}

parameter="$1"
if test ${parameter} = "white"; then
    white_theme
elif test ${parameter} = "black"; then
    black_theme
else
    swap_theme
fi
