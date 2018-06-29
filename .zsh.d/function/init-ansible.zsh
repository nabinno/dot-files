export ANSIBLE_HOST_KEY_CHECKING=false
export PATH=~/.ans/bin:$PATH
export ANS_PROJECTS_PATH=~/toki

get-ansible() {
  pip install \
    ansible \
    apache-libcloud
  mkdir -p ~/.gcp
}
if ! type -p ansible-playbook >/dev/null; then get-ansible; fi

# ----------------------------------------------------------------------
# ### ans (ansible wrapper) ###
get-ans() {
  case "${OSTYPE}" in
    freebsd* | darwin* | linux*)
      git clone https://github.com/nabinno/ans ~/.ans
      eval "$(ans init -)"
      ;;
  esac
}
if ! type -p ans >/dev/null; then get-ans; fi
if type -p ans >/dev/null; then eval "$(ans init -)"; fi
