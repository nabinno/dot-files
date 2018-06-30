# ### dove ###
export PATH="$HOME/.local/dove/bin:$PATH"

get-dove() {
  git clone git@github.com:nabinno/dove.git ~/.local/dove
}
if [ ! -d ~/.local/dove ]; then get-dove; fi

cd-dove() {
  dove_path=$(which dove)
  dove_dir=$(dirname $dove_path)
  cd $dove_dir/../$1
}
alias zd=cd-dove

# ----------------------------------------------------------------------
# ### dotfiles ###
push-dotfiles() {
  while getopts ":c:m:ih" opt; do
    case $opt in
      "c") is_credential=true ;;
      "m") is_mu4e=true ;;
      "e") is_esa=true ;;
      "r") is_irc=true ;;
      "i") is_init_el=true ;;
      "h")
        echo ''
        echo "Usage: get-dotfiles [-mih]" 1>&2
        is_exit=true
        ;;
      "?")
        echo "$0: Invalid option -$OPTARG" 1>&2
        echo "Usage: $0 [-mih]" 1>&2
        is_exit=true
        ;;
    esac
  done

  if ! [ $is_exit ]; then
    cd ~/
    if [ ! -d ~/.local/dotfiles ]; then
      mkdir -p ~/.local
      sh -c "$(curl -fsSL https://raw.github.com/nabinno/dotfiles/master/install)"
      wait
    fi
    cd ~/.local/dotfiles
    git checkout -- .
    git checkout master
    git pull
    rm -rf .emacs.d/lisp/*
    cp -pr ~/.emacs.d/lisp/* .emacs.d/lisp/
    cp -pr ~/.emacs.d/bin/* .emacs.d/bin/
    cp -pr ~/.emacs.d/eshell/alias .emacs.d/eshell/
    cp -pr ~/.emacs.d/init.el .emacs.d/
    cp -pr ~/.zsh.d/function/* .zsh.d/function/
    cp -pr ~/.offlineimap.py .
    cp -pr ~/.aspell.conf .
    cp -pr ~/.zshenv .
    cp -pr ~/.zshrc .
    cp -pr ~/.docker .
    cp -pr ~/.rufo .
    cp -pr ~/.iex .
    rm -rf ~/.local/dotfiles/.docker/config.json
    rm -rf ~/.local/dotfiles/.docker/etc/nginx/conf.d/*
    case "${OSTYPE}" in freebsd* | darwin* | linux*) cp -pr ~/.screenrc . ;; esac
    if ! [ $is_credential ]; then git checkout -- .emacs.d/lisp/init-credential.el; fi
    if ! [ $is_mu4e ]; then git checkout -- .emacs.d/lisp/init-mu4e.el; fi
    if ! [ $is_esa ]; then git checkout -- .emacs.d/lisp/init-esa.el; fi
    if ! [ $is_irc ]; then git checkout -- .emacs.d/lisp/init-irc.el; fi
    if ! [ $is_init_el ]; then git checkout -- .emacs.d/init.el; fi
  fi
}
alias zp=push-dotfiles

fetch-dotfiles() {
  # pre proc
  local current_pwd=$(pwd)
  cd ~/
  if [ ! -d ~/.local/dotfiles ]; then
    mkdir -p ~/.local
    sh -c "$(curl -fsSL https://raw.github.com/nabinno/dotfiles/master/install)"
    wait
  fi
  cd ~/.local/dotfiles
  git checkout -- .
  git checkout master
  git pull
  rm -rf .emacs.d/lisp/init-mu4e.el
  rm -rf .emacs.d/lisp/init-esa.el
  rm -rf .emacs.d/lisp/init-credential.el

  # main proc
  cp -pr .emacs.d/lisp/* ~/.emacs.d/lisp/
  cp -pr .emacs.d/bin/* ~/.emacs.d/bin/
  cp -pr .emacs.d/eshell/alias ~/.emacs.d/eshell/
  cp -pr .emacs.d/init.el ~/.emacs.d/
  cp -pr .zsh.d/function/* ~/.zsh.d/function/
  cp -pr .offlineimap.py ~/
  cp -pr .aspell.conf ~/
  cp -pr .zshenv ~/
  cp -pr .zshrc ~/
  cp -pr .docker ~/
  cp -pr .rufo ~/
  cp -pr .iex ~/
  case "${OSTYPE}" in freebsd* | darwin* | linux*) cp -pr .screenrc ~/ ;; esac

  # post proc
  git checkout -- .emacs.d/lisp/init-mu4e.el
  git checkout -- .emacs.d/lisp/init-esa.el
  git checkout -- .emacs.d/lisp/init-credential.el
  cd $current_pwd
  exec -l zsh
}
alias zf=fetch-dotfiles

gresreg() {
  for i in $(\grep -lr $1 *); do
    cp $i $i.tmp
    sed -e "s/$1/$2/g" $i.tmp >$i
    rm $i.tmp
  done
}

kl() {
  kill -f $1
}

chpwd() {
}

# chpwd() {
#   ll
# }

lower() {
  for i in "$@"; do
    \mv -f $i $(echo $i | tr "[:upper:]" "[:lower:]")
  done
}

upper() {
  for i in *; do
    \mv -f $i $(echo $i | tr "[:lower:]" "[:upper:]")
  done
}

rename() {
  for i in *$1*; do
    \mv -f $i $(echo $i | sed -e s,$1,$2,g)
  done
}

rename-recursively() {
  find . -print | while read file; do
    \mv -f $file ${file//$1/$2}
  done
}

rr() {
  exec -l zsh
}

rename() {
  for i in *$1*; do
    \mv -f $i # (echo $i | sed -e s,$1,$2,g)
  done
}

rename-recursively() {
  find . -print | while read file; do
    \mv -f $file ${file//$1/$2}
  done
}

# t() {
#   \mv (.*~|.*.org*|*.org*|*.tar.gz|*.stackdump|*.tar.gz|*.asx|*.0|*.msi|*.wav|*.doc|*.pdf|$1) .old/
# }

bkup() {
  cp -ipr $1 $1.org$(date +%y%m%d)
}

bkup-targz() {
  tar zcvf $2$(date +%y%m%d)_$1_$(date +%H).tar.gz $3$1
}

# ----------------------------------------------------------------------
# ### other ###
alias b='bkup'
alias bU='bkup-targz'
alias bin='~/bin'
alias c='/bin/cp -ipr'
alias d='/bin/rm -fr'
alias du="du -h"
alias df="df -h"
# alias grep='egrep -ano'
# alias egrep='egrep --color=auto'
alias MK="make deinstall"
alias e='emacsclient -t'
alias egrep='\egrep -H -n'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ic='cat /proc/cpuinfo'
alias ij='jobs -l'
alias im='cat /proc/meminfo'
alias in='netstat -a -n | more'
alias it="date -R"
alias j='cd'
alias k='/bin/mkdir -p'
alias lw='lower'
alias m='/bin/mv'
alias mk="make config install distclean"
alias pwd='pwd -P'
alias r='/bin/mv'
alias re='e ~/.zshrc'
alias reb='cp -ip ~/.zshrc ~/.zshrc.org$(date +%y%m%d)'
alias rn="rename"
alias rn="rename"
alias rnr="rename-recursively"
alias rnr="rename-recursively"
alias s='/bin/ln -s'
alias scp='/usr/bin/scp -Cpr'
alias up="upper"
# alias su="su -l"
alias u='tar zxvf'
alias U='tar zcvf $1.tar.gz $1'
alias uz='unzip'
alias v="cat"
case "${OSTYPE}" in
  freebsd* | darwin*) alias ip="ps aux" ;;
  cygwin | msys) alias ip="ps -flW" ;;
  linux*)
    case "${DIST}" in
      Redhat | RedHat) alias ip="ps aux" ;;
      Debian | Ubuntu) alias ip="ps aux" ;;
    esac
    ;;
esac
