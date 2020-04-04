export EDITOR=nvim
export VISUAL=nvim
export TERM=st-256color
export LC_ALL='en_US.UTF-8'

export _JAVA_AWT_WM_NONREPARENTING=1

export PATH="$PATH:/home/ale-cci/scripts:$(ruby -e 'puts Gem.user_dir')/bin:/home/ale-cci/projects/tw"
export GEM_HOME=$HOME/.gem
export GEM_PATH=$HOME/.gem

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
