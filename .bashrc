# .bashrc file
# By Balaji S. Srinivasan (balajis@stanford.edu)
#
# Concept: .bashrc is the *non-login* config for bash.
#          .bash_profile is the *login* config for bash.
#
#
# When using GNU screen:
#
#    1) .bash_profile is loaded the first time you login, and should be used
#       only for paths and environmental settings
#
#    2) .bashrc is loaded in each subsequent screen, and should be used for
#       aliases and stuff like writing to the infinite bash history
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


# --------------------------------
# -- 1) Set up umask permissions
# --------------------------------
#  The following incantation allows easy group modification of files.
#  See here: http://en.wikipedia.org/wiki/Umask
#
#     umask 002 allows only you to write (but the group to read) any new files that you create.
#     umask 022 allows both you and the group to write to any new files which you make.
#
#  In general we want umask 022 on the server and umask 002 on local machines.
#
#  The command 'id' gives the info we need to distinguish these cases.
#     $ id -gn  #gives group name
#     $ id -un  #gives user name
#     $ id -u   #gives user ID
#
#  So: if the group name is the same as the username OR the user id is
#  not greater than 99 (i.e. not root or a privileged user), then we are
#  on a local machine (check for yourself), so we set umask 002.
#
#  Conversely, if the default group name is *different* from the username
#  AND the user id is greater than 99, we're on the server, and set umask
#  022 for easy collaborative editing.
if [ "`id -gn`" == "`id -un`" -a `id -u` -gt 99 ]; then
	umask 002
else
	umask 022
fi

# -----------------------------------------------------
# -- 2) Set up bash prompt and ~/.bash_eternal_history
# -----------------------------------------------------
#  Set various bash parameters based on whether the shell is 'interactive' or
#  not.  An interactive shell is one you type commands into, a
#  non-interactive one is the bash environment used in scripts.
if [ "$PS1" ]; then

    if [ -x /usr/bin/tput ]; then
      if [ "x`tput kbs`" != "x" ]; then # We can't do this with "dumb" terminal
        stty erase `tput kbs`
      elif [ -x /usr/bin/wc ]; then
        if [ "`tput kbs|wc -c `" -gt 0 ]; then # We can't do this with "dumb" terminal
          stty erase `tput kbs`
        fi
      fi
    fi
    case $TERM in
	xterm*)
		if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
			PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
		else
	    	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
		fi
		;;
	screen)
		if [ -e /etc/sysconfig/bash-prompt-screen ]; then
			PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
		else
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
		fi
		;;
	*)
		[ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default

	    ;;
    esac

    # Bash eternal history
    # --------------------
    # This snippet allows infinite recording of every command you've ever
    # entered on the machine, without using a large HISTFILESIZE variable,
    # and keeps track if you have multiple screens and ssh sessions into the
    # same machine. It is adapted from:
    # http://www.debian-administration.org/articles/543.
    #
    # The way it works is that after each command is executed and
    # before a prompt is displayed, a line with the last command (and
    # some metadata) is appended to ~/.bash_eternal_history.
    #
    # This file is a tab-delimited, timestamped file, with the following
    # columns:
    #
    # 1) user
    # 2) hostname
    # 3) screen window (in case you are using GNU screen, which you should!)
    # 4) date
    # 5) current working directory (very useful to see *where* a command was run)
    # 6) the last command you executed
    #
    # The only minor bug: if you include a literal tab (e.g. with awk
    # -F"\t"), then that messes up the formatting a bit. If you have a fix
    # for that which doesn't slow the command down, please submit a patch.
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo -e $$\\t$USER\\t$HOSTNAME\\tscreen $WINDOW\\t`date +%D%t%T%t%Y%t%s`\\t$PWD"$(history 1)" >> ~/.bash_eternal_history'

    # Turn on checkwinsize
    shopt -s checkwinsize

    #Prompt edited from default
    [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u \w]\\$ "

    if [ "x$SHLVL" != "x1" ]; then # We're not a login shell
        for i in /etc/profile.d/*.sh; do
	    if [ -r "$i" ]; then
	        . $i
	    fi
	done
    fi
fi


#1.4) Append to history and make prompt nice.
#See: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
shopt -s histappend
#PROMPT_COMMAND='history -a'

#See:  http://www.ukuug.org/events/linux2003/papers/bash_tips/
PS1="\[\033[0;34m\][\u@\h:\w]$\[\033[0m\]"



## -----------------------
## -- 2) Set up aliases --
## -----------------------

 #2.1) Safety
 alias rm="rm -i"
 alias mv="mv -i"
 alias cp="cp -i"
 set -o noclobber

 #2.2) Listing, directories, and motion
 alias ll="ls -alrtF --color"
 alias la="ls -A"
 alias l="ls -CF"
 alias dir='ls --color=auto --format=vertical'
 alias vdir='ls --color=auto --format=long'
 alias m='less'
 alias ..='cd ..'
 alias ...='cd ..;cd ..'
 alias md='mkdir'
 alias cl='clear'
 alias du='du -ch --max-depth=1'
 alias treeacl='tree -A -C -L 2'

 #2.3) Jump to common directories
 alias desk='cd ~/Desktop'
 alias doc='cd ~/Documents'
 alias dl='cd ~/downloads'
 alias res='cd ~/Documents/research';
 alias ppr='cd ~/Documents/papers';
 alias cls='cd ~/Documents/classes';

 #2.4) Text and editor commands
 alias em='emacs -nw'
 alias awk='gawk'
 alias sus="sort | uniq -c | sort -k1 -rn"
 alias coldiff='colordiff -W 180 --suppress-common-lines -d -y'

 #2.5) Better defaults for common commands
 alias bc='bc -lqw'
 #alias emacs='emacs-screen.sh -nw'
 #alias emacs='emacs -nw'
 alias emacs='emacs -nw'
 alias eq='emacs -nw -Q --load ~/.emacs-quick' #quick w/ basic global keybindings (e.g. for C-h)
 alias eqq='emacs -nw -Q' #quickest
 alias plink='plink --noweb'
 alias hn='hostname'
 alias ocaml='rlwrap ocaml' #rlwrap = give readline support to *any* application. Very, very useful for Ocaml interpreter.
 alias lesst='less -S --tab=40'
 alias lessrs='less -R -S'
 alias rsyncavp='rsync -av --progress'
 alias curlso='curl -s -O' # download a single URL silently, writing to the same file extensions
 alias gtime="/usr/bin/time -v " #VERY useful. GNU Time crushes the bash builtin
 alias brc="emacs ~/.bashrc"
 alias lynxf='lynx --force_html' #quick dumping to html

 #2.6) Python tricks
 alias ppm="ipython -i -c 'from base.science.ltc.models import *; setup_all();'" #Quick model explore
 alias pp="python -i -c 'from base.science.ltc.models import *; from pylab import *; import numpy as np; import scipy as sp; from base.science.include.utils.autoimp import *'" #Quick plotting with matplotlib
 alias where_is_python_site_packages='python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"'
 alias findpy="find -name '*.py' -type f"
 alias cb="python setup.py build_ext --inplace" #rebuild cython modules
 alias cbf="python setup.py build_ext --inplace --force" #rebuild cython modules, forcibly

 #2.7) Git abbreviations
 alias gts="git status"
 alias gtpr="cd ~/base; git pull --rebase"
 alias gtpu="cd ~/base; git push"
 alias cse='cd ~/base/science/experimental'
 alias gtl="git log --numstat"

 #2.8) Latex tricks
 alias xlt='xelatex -shell-escape' #See: python-in-latex-examples.tex.
 alias plt='pdflatex -shell-escape' #See: python-in-latex-examples.tex.

 #2.9) Bug reporting on OSX
 #alias pbclean='pbpaste | cut -c1-120 | pbcopy' #When copying and pasting from a wide terminal, pull out the first 120 columns (should be sufficient for most purposes)
 alias pbclean='pbpaste | sed "s/[[:blank:]]\+$//g" | pbcopy' #Removes all trailing spaces without cropping

 #2.10) Rapid browsing w/ conkeror
 alias conkeror='open /Applications/conkeror.mozdev.org/conkeror.app'

 #2.11) Global options
 export GREP_OPTIONS='--color=auto' #default grep colorization
 export GREP_COLOR='1;31'  #sets color to green
 # 2.11.1) Sorting configuration
 # If you are doing big sorts...you want GNU sort to behave in a cross platform way.
 # After getting burned by locale issues one too many times...I have this in every .bashrc.
 #
 # See e.g.
 # http://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021
 unset LANG
 export LC_ALL=POSIX

 #2.12) Haskell
 export haskell_doc='open opt/local/share/ghc-6.10.4/doc/ghc/libraries/index.html'

 #2.13) git-upload-pack hack
 # See here: http://stackoverflow.com/questions/225291/git-upload-pack-command-not-found-how-to-fix-this-correctly
 export PATH=/usr/local/git/bin/:$PATH   #Git special install on storage

# if [ "`uname -a | grep 'Darwin' | wc -l`" = "1" ]; then
#     # on a mac, do nothing
#     asdf=1 + 1
# else
#    # Recursive include of directories under ~/bin, allows aggressive symlinking of code from db.git
#    # http://stackoverflow.com/questions/657108/bash-recursively-adding-subdirectories-to-the-path
#    #export PATH="${PATH}$(find ~/bin -name '.*' -prune -o -type d -printf ':%p')"
# fi


 #2.14) Javascript shells
 #alias rhino="rlwrap java -jar "$HOME"/downloads/rhino1_7R2/js.jar"
 #alias v8d="rlwrap "$HOME"/downloads/v8/d8"
 #alias v8="rlwrap "$HOME"/downloads/v8/shell"

 #2.15) JS GUI
 export CAPP_BUILD=$HOME/cappucino

 #2.16) mozrepl for running Firefox and scripting JS from within Emacs/CLI/Conkeror
 alias mozrepl='rlwrap telnet localhost 4242' #Make sure to do Firefox -> Tools -> MozRepl -> Start (or Activate on Startup)
 export JSLINT_HOME=$HOME/dotfiles/generic/emacs/lang/javascript/jslint_cli

 #2.16) Srini
 alias srini='cd ~/srini'
 alias srinirl='cd ~/srini/srini_release'
 alias srinidb='cd ~/srini/db/srini_db'

 #2.17) node.js
 alias node="env NODE_NO_READLINE=1 rlwrap node"
 export NODE_DISABLE_COLORS=1
 if [ -s ~/nvm/nvm.sh ]; then
     NVM_DIR=~/nvm
     source ~/nvm/nvm.sh
     nvm use 0.8
 fi

 #2.18) pygmentize
 alias pcat="pygmentize -g"

 #2.19) hscp
 # UDT (udt.sf.net) is a library with C++/JNI/.net API
 # and only has a simple command line tool. HSCP
 # (http://sourceforge.net/projects/hscp/), is a SCP-like tool
 # but uses UDT for data transfer. Both UDT and HSCP are open source
 # and free to use, and potentially better than Aspera.
 export HSCP_CONF=$HOME/hscp.conf

 #2.20) Hack for VCF tools perl module, for Sanger Variant Call Format
 export PERL5LIB=$HOME/bin/vcftools-latest/lib:${PERL5LIB}

 #2.21) Set up djb redo directory coloration
 # See github.com/apenwarr/redo/README.md
 # Use this method as it's more explicit than eval.
 #
 # dircolors ~/.dircolors.conf produces this:
 # LS_COLORS='*.do=00;35:*Makefile=00;35:*.o=00;30;1:*.pyc=00;30;1:*~=00;30;1:*.tmp=00;30;1:';

 # 00;30;1 = dark black/bold
 # 00;31;1 = red
 # 00;32;1 = green
 # 00;33;1 = yellow
 # 00;34;1 = dark blue (directory color)
 # 00;35;1 = magenta
 # 00;36;1 = light blue
 # 00;37;1 = gray (this is what we want for .pyc, etc. files)
 # 00;38;1 = light blue

 #2.22) Counsyl /data
 export COUNSYL_DATA_DIR='/data'

 # 2.23) Colorized pygments (sudo easy_install pygments
 alias page='LESSOPEN="|pygmentize -g %s" less -R'

 # 2.24) Worldbase default path
 #export WORLDBASEPATH='/data/pygr'

 # 2.25) Heroku
 # https://toolbelt.heroku.com/standalone
 export PATH=/usr/local/heroku/bin:$PATH

## --------------------------------
## -- 3) User specific stuff  --
## --------------------------------

## Load user customized bashrc
source ~/.bashrc_custom
source .bashrc.darwin.homebrew

alias python='python -Wignore::DeprecationWarning'


# http://www.askapache.com/dreamhost/wget-header-trick.html
function wgets()
{
  wget --referer="http://www.google.com" --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" \
  --header="Accept:text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" \
  --header="Accept-Language: en-us,en;q=0.5" \
  --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" \
  --header="Keep-Alive: 300" "$@"
}

# argh autocompletion
# See: argh/scripts/bash_completion.sh
# Doesn't fully work. See how to get this to work.

# _argh_completion()
# {
#     COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
#                    COMP_CWORD=$COMP_CWORD \
#                    ARGH_AUTO_COMPLETE=1 $1 ) )
# }
# export DJANGO_PROG=$HOME/base/site/counsyl/product/seq/commands.py
# complete -F _argh_completion DJANGO_PROG


#Copyright Joel Schaerer 2008, 2009
#This file is part of autojump

#autojump is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#autojump is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with autojump.  If not, see <http://www.gnu.org/licenses/>.
_autojump()
{
        local cur
        COMPREPLY=()
        unset COMP_WORDS[0] #remove "j" from the array
        cur=${COMP_WORDS[*]}
        IFS=$'\n' read -d '' -a COMPREPLY < <(autojump --bash --completion "$cur")
        return 0
}
complete -F _autojump j
AUTOJUMP='{ (autojump -a "$(pwd -P)"&)>/dev/null 2>>${HOME}/.autojump_errors;} 2>/dev/null'
if [[ ! $PROMPT_COMMAND =~ autojump ]]; then
  export PROMPT_COMMAND="${PROMPT_COMMAND:-:} && $AUTOJUMP"
fi
alias jumpstat="autojump --stat"
function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";fi }


