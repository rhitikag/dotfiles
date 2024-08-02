# ~/.profile
#
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

case "$(tty)" in
/dev/tty1) exec startx ;;
/dev/tty2) exec Hyprland ;;
esac
