function get-heroku() {
  case "${OSTYPE}" in
    freebsd* | darwin*) nix-install heroku-3.43.16 ;;
    linux*)
      case "${DIST}" in
        Redhat | RedHat | Debian)
          wget -qO- https://toolbelt.heroku.com/install.sh | sudo sh
          /usr/local/heroku/bin/heroku
          ;;
        Ubuntu)
          parts install \
            heroku_toolbelt \
            hk
          ;;
      esac
      ;;
  esac
}
