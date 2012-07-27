#!/bin/sh #
# ~/.xinitrc
#

# source xinitc.d scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# load .Xresources
[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

# remap caps lock to escape, remap right alt to window key
setxkbmap -option caps:escape
xmodmap -e "keycode 108 = Super_L"
xmodmap -e "remove mod1 = Super_L"

# add font paths
xset fp default
[[ -d /usr/share/fonts/local ]] && xset +fp /usr/share/fonts/local
[[ -d $HOME/.fonts ]] && xset +fp $HOME/.fonts
xset fp rehash

# turn monitor off after 60min
xset s off
xset dpms 3600 3600 3600

# increase mouse acceleration
xset m 3

# set WM to a name with Java recognises
wmname LG3D

# set background
sh $HOME/.fehbg &

# start apps in background (only if not already running)
list=(dropbox mpd tmux transmission-daemon urxvtd)
for app in "${list[@]}"; do
  check=$(ps -C "$app" -opid=)
  if [[ -z "$check" ]]; then
    case "$app" in
      dropbox) dropboxd & ;;
      mpd) mpd ;;
      tmux) tmux & ;;
      transmission-daemon) transmission-daemon ;;
      urxvtd) urxvtd -q -o -f ;;
    esac
  fi
done

# start WM
exec $HOME/bin/dwm-start