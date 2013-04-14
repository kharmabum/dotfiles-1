# .bash_profile file
# By Balaji S. Srinivasan (balajis@stanford.edu)
#
# Concept: .bashrc is the *non-login* config for bash.
#          .bash_profile is the *login* config for bash.
#
# When using GNU screen:
#
#    1) .bash_profile is loaded the first time you login, and should be used
#       only for paths and environmental settings.
#
#    2) .bashrc is loaded in each subsequent screen, and should be used for
#       aliases and things like writing to the infinite bash history.
#
# See here or do 'man bashrc' for the long version:
# http://en.wikipedia.org/wiki/Bash#Startup_scripts
#
# When Bash starts, it executes the commands in a variety of different scripts.
#
#   1) When Bash is invoked as an interactive login shell, it first reads
#      and executes commands from the file /etc/profile, if that file
#      exists. After reading that file, it looks for ~/.bash_profile,
#      ~/.bash_login, and ~/.profile, in that order, and reads and executes
#      commands from the first one that exists and is readable.
#
#   2) When a login shell exits, Bash reads and executes commands from the
#      file ~/.bash_logout, if it exists.
#
#   3) When an interactive shell that is not a login shell is started
#      (e.g. a GNU screen session), Bash reads and executes commands from
#      ~/.bashrc, if that file exists. This may be inhibited by using the
#      --norc option. The --rcfile file option will force Bash to read and
#      execute commands from file instead of ~/.bashrc.

## -----------------------
## -- 1) Import .bashrc --
## -----------------------

# Factor out all repeated profile initialization into .bashrc
# - All non-login shell parameters go there
# - Declarations that need to be repeated for each screen session.
source $HOME/.bashrc

# Configure PATH
# - These are line by line so that you can kill one without affecting the others.
# - Lowest priority first, highest priority last.
export PATH=$PATH
export PATH=~/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/heroku/bin:$PATH # Heroku: https://toolbelt.heroku.com/standalone

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
