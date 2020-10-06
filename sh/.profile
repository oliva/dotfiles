# ~/.profile: executed by the command interpreter for login shells.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

#SSH agents
export SSH_ASKPASS=ssh-askpass
[[ ! -S /run/user/${UID}/ssh-agent ]] && ssh-agent -a /run/user/${UID}/ssh-agent >&-
export SSH_AUTH_SOCK=/run/user/${UID}/ssh-agent

#Editors
export VISUAL=nvim
export DIFF=nvim\ -d

#Disable flow control
stty -ixon

#Fix Java AWT theme, font smoothing and empty windows
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

#Proper output for Ansible
export ANSIBLE_NOCOWS=1

#Wayland support
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export _JAVA_AWT_WM_NONREPARENTING=1
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

#QT5 config tool theme
export QT_GRAPHICSSYSTEM=native
export QT_QPA_PLATFORMTHEME=qt5ct

#Keyboard options
export XKB_DEFAULT_MODEL=pc105
export XKB_DEFAULT_LAYOUT=us,hu
export XKB_DEFAULT_VARIANT=,102_qwerty_comma_dead
export XKB_DEFAULT_OPTIONS=grp:caps_toggle,grp_led:caps,compose:prsc,numpad:mac

#ESP env
export ESPIDF=/opt/esp-idf-sdk

#Colorspace for Blender
export OCIO=$HOME/Data/filmic-blender/config.ocio

#Support for tray icons on shit applications
export XDG_CURRENT_DESKTOP=Unity
