function get-shellcheck() {
  case $OSTYPE in
    linux*)
      case $DIST in
        Ubuntu) sudo apt-get install shellcheck ;;
      esac
      ;;
  esac
}
