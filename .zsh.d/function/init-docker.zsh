case $DIST_VERSION in 16.04) export DOCKER_HOST=tcp://:2375 ;; esac

### setup ###
get-docker() {
  case "${OSTYPE}" in
    msys | cygwin) choco install boot2docker ;;
    freebsd* | darwin*) ;;
    linux*)
      case "${DIST}" in
        Redhat | RedHat)
          sudo yum update
          sudo yum install -y yum-util
          sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
          sudo yum-config-manager --disable docker-ce-edge
          sudo yum makecache fast
          sudo yum install -y docker-ce
          local current_user_name=$(whoami)
          sudo usermod -aG docker ${current_user_name}
          ;;
        Debian)
          sudo apt-get update
          sudo apt-get install -y docker.io
          local current_user_name=$(whoami)
          sudo usermod -aG docker ${current_user_name}
          ;;
        Ubuntu)
          case $DIST_VERSION in
            12.04 | 14.04)
              sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
              if [ -f /etc/apt/sources.list.d/docker.list ]; then
                sudo rm /etc/apt/sources.list.d/docker.list
                sudo touch /etc/apt/sources.list.d/docker.list
              fi
              case "${DIST_VERSION}" in
                12.04) sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" >> /etc/apt/sources.list.d/docker.list' ;;
                14.04) sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >> /etc/apt/sources.list.d/docker.list' ;;
              esac
              sudo apt-get update
              sudo apt-get purge lxc-docker*
              sudo apt-cache policy docker-engine
              sudo apt-get update
              sudo apt-get install -y docker-engine
              local current_user_name=$(whoami)
              sudo usermod -aG docker ${current_user_name}
              ;;
            16.04)
              sudo apt install docker
              ;;
          esac
          ;;
      esac
      ;;
  esac
}
case $OSTYPE in linux) if ! type -p docker >/dev/null; then get-docker; fi ;; esac

set-docker-as-app-group() {
  case "${OSTYPE}" in
    linux*)
      case "${DIST}" in
        Redhat | RedHat)
          sudo groupadd -g 9999 app
          sudo useradd -g 9999 -u 9999 app
          echo app | sudo passwd app --stdin
          sudo usermod -aG docker app
          echo "app ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
          ;;
      esac
      ;;
  esac
}

remove-docker() {
  case "${OSTYPE}" in
    linux*)
      case "${DIST}" in
        Redhat | RedHat)
          sudo yum remove -y \
            docker \
            docker-common \
            container-selinux \
            docker-selinux \
            docker-engine
          ;;
      esac
      ;;
  esac
}

docker-restart() {
  case "${OSTYPE}" in
    darwin* | linux*)
      sudo service docker stop
      sudo service docker start
      sudo service docker status
      ;;
  esac
}

docker-status() {
  case "${OSTYPE}" in
    darwin* | linux*) sudo service docker status ;;
  esac
}

# ----------------------------------------------------------------------
## ### alias ###
# alias docker='docker'
case $DIST_VERSION in 16.04) alias docker="DOCKER_HOST=${DOCKER_HOST} docker" ;; esac
case $DIST_VERSION in 16.04) alias docker-compose="docker-compose -H ${DOCKER_HOST}" ;; esac
alias dcr="docker-restart"
alias dcp="ps aux | \grep -G 'docker.*'"
alias dcs="docker-status"
alias dck="sudo killall docker"
alias dc='docker commit $(docker ps -l -q)'
alias dd='docker rmi -f'
alias dda='docker rmi -f $(docker images -q)'
alias ddel='docker rmi -f'
alias ddela='docker rmi -f $(docker images -q)'
alias de='docker exec -it '
alias di='docker info'
alias dinspect='docker inspect'
alias dj='docker exec -it'
alias dk='docker rm -f'
alias dka='docker rm -f $(docker ps -a -q)'
alias dkd='dka ; dda'
alias dkill='docker rm -f'
alias dkilla='docker rm -f $(docker ps -a -q)'
alias dl='docker images'  # | less -S
alias dls='docker images' # | less -S
alias dn='docker network'
alias dp='docker ps -a --format "table {{.Names}}\t{{.Command}}\t{{.Status}}\t{{.Ports}}"'  # | less -S
alias dps='docker ps -a --format "table {{.Names}}\t{{.Command}}\t{{.Status}}\t{{.Ports}}"' # | less -S
alias dr='docker restart'
alias dt='docker tag'
alias dtop='docker top'
alias dv='docker version'

dcc() {
  (cd ~/.docker && docker-compose $1)
}

dce() {
  docker exec -it "docker_$1_1" $2
}

dh() {
  docker history $1 | less -S
}

dsshd() {
  docker run -t -d -p 5000:3000 -P $1 /usr/sbin/sshd -D
}

datach() {
  docker start $1
  docker atach $1
}

denv() {
  docker exec $1 env
}

dip() {
  CI=$(docker ps -l -q)
  if [ $1 ]; then
    docker inspect --format {{.NetworkSettings.IPAddress}} $1
    docker inspect --format {{.NetworkSettings.Ports}} $1
  else
    docker inspect --format {{.NetworkSettings.IPAddress}} $CI
    docker inspect --format {{.NetworkSettings.Ports}} $CI
  fi
}

dnsenter() {
  CI=$(docker ps -l -q)
  if [ $1 ]; then
    PID=$(docker inspect --format {{.State.Pid}} $1)
    nsenter --target $PID --mount --uts --ipc --net --pid
  else
    PID=$(docker inspect --format {{.State.Pid}} $CI)
    nsenter --target $PID --mount --uts --ipc --net --pid
  fi
}

# ----------------------------------------------------------------------
# ### docker compose / machine ###
get-docker-compose() {
  case $OSTYPE in
    freebsd* | darwin*)
      pip install docker-compose
      ;;
    linux*)
      case $DIST in
        RedHat | Redhat | Debian)
          pip install docker-compose
          ;;
        Ubuntu)
          case $DIST_VERSION in
            12.04 | 14.04)
              pip install docker-compose
              ;;
            16.04)
              sudo apt install docker-compose
              ;;
          esac
          ;;
      esac
      ;;
  esac
}

get-docker-machine() {
  case "${OSTYPE}" in
    freebsd* | darwin*) ;;
    linux*)
      case "${DIST}" in
        Redhat | RedHat) ;;
        Debian | Ubuntu)
          wget https://github.com/docker/machine/releases/download/v0.1.0/docker-machine_linux-386 -O ~/.local/bin/docker-machine
          chmod +x ~/.local/bin/docker-machine
          ;;
      esac
      ;;
  esac
}
if ! type -p docker-compose >/dev/null; then get-docker-compose; fi
if ! type -p docker-machine >/dev/null; then get-docker-machine; fi

case $OSTYPE in
  msys)
    export DOCKER_PATH=$(get-winpath "C:\Program Files\Docker Toolbox")

    boot2docker() {
      local current_pwd=$(pwd)
      cd $DOCKER_PATH
      ./start.sh
      cd $current_pwd
    }

    alias docker="MSYS_NO_PATHCONV=1 $DOCKER_PATH/docker.exe"
    alias docker-compose="$DOCKER_PATH/docker-compose.exe"
    alias docker-machine="$DOCKER_PATH/docker-machine.exe"
    alias dcmu="docker-machine start"
    alias dcmt="docker-machine stop"
    alias dcmr="docker-machine restart"
    alias dcmssh='docker-machine ssh'
    alias dcmscp='docker-machine scp'
    alias dcp="ps aux | \grep -G 'docker.*'"
    alias dcms="docker-machine status"
    alias dcmd='docker-machine kill -f'
    alias dcmdel='docker-machine kill -f'
    alias dcmj='docker-machine ssh'
    alias dcmk='docker-machine rm -f'
    alias dcmkill='docker-machine rm -f'
    alias dcml='docker-machine config ; docker-machine env'
    alias dcmls='docker-machine config ; docker-machine env'
    alias dcmp='docker-machine ls'
    alias dcmps='docker-machine ls'
    ;;
esac

case "${OSTYPE}" in
  msys | cygwin | freebsd* | darwin* | linux*)
    if [ -f ~/.docker/docker-compose.zsh ]; then source ~/.docker/docker-compose.zsh; fi
    ;;
esac
