# Ab
function get-ab() {
  case "${OSTYPE}" in
    freebsd* | darwin*) ;;
    linux*)
      case "${DIST}" in
        Redhat | RedHat) sudo yum install -y httpd-tools ;;
        Debian | Ubuntu) sudo apt-get install -y apache2-utils ;;
      esac
      ;;
  esac
}
if ! type -p ab >/dev/null; then get-ab; fi

# ----------------------------------------------------------------------
# Wrk
function get-wrk() {
  case "${OSTYPE}" in
    freebsd*) ;;
    darwin*) brew install wrk ;;
    linux*)
      case "${DIST}" in
        Redhat | RedHat)
          cd ~
          sudo yum groupinstall 'Development Tools'
          sudo yum install openssl-devel
          git clone https://github.com/wg/wrk.git
          cd wrk && make && cp wrk ~/.local/bin
          cd ~ && rm -fr wrk
          ;;
        Debian | Ubuntu)
          case $DIST_VERSION in
            14.04)
              cd ~
              sudo apt-get install build-essential libssl-dev
              git clone https://github.com/wg/wrk.git
              cd wrk && make && cp wrk ~/.local/bin
              cd ~ && rm -fr wrk
              ;;
            16.04) sudo apt install -y wrk ;;
          esac
          ;;
      esac
      ;;
  esac
}
if ! type -p wrk >/dev/null; then get-wrk; fi
