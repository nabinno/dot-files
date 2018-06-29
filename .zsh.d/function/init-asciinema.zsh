get-asciinema() {
  case $OSTYPE in
    linux*)
      case $DIST in
        Redhat | RedHat)
          sudo yum install asciinema
          ;;
        Debian)
          sudo apt-get install asciinema
          ;;
        Ubuntu)
          sudo apt-add-repository ppa:zanchey/asciinema
          sudo apt-get update
          sudo apt-get install asciinema
          ;;
      esac
      ;;
  esac
}
if ! type -p asciinema >/dev/null; then get-asciinema; fi
