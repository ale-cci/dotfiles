export EDITOR=nvim
export VISUAL=nvim
export LC_ALL='en_US.UTF-8'


export GEM_HOME=$HOME/.gem
export GEM_PATH=$HOME/.gem

export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$HOME/.local/bin:$PATH
export PATH="$PATH:/home/ale-cci/scripts:$(ruby -e 'puts Gem.user_dir')/bin:/home/ale-cci/projects/tw"

export _JAVA_AWT_WM_NONREPARENTING=1

export ANDROID_HOME=$HOME/Android/Sdk
export JAVA_HOME=/usr/lib/jvm/default
export ANDROID_SDK=$HOME/Android/Sdk

# Custom projects
export BEIFI_DIR=$HOME/projects/beifi-web
export BEIFI_MOBILE_DIR=$HOME/projects/beifi-app

# Config files
export LESSHISTFILE=$HOME/.cache/.lesshst
export PATH=/home/ale-cci/Android/Sdk/platform-tools:$PATH
