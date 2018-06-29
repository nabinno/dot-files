get-powershell() {
  case "${OSTYPE}" in
    linux*)
      case "${DIST}" in
        Redhat | RedHat)
          sudo yum install https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.15/powershell-6.0.0_alpha.15-1.el7.centos.x86_64.rpm
          ;;
        Ubuntu)
          case "${DIST_VERSION=}" in
            14.04)
              wget https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.15/powershell_6.0.0-alpha.15-1ubuntu1.14.04.1_amd64.deb
              sudo dpkg -i powershell_6.0.0-alpha.15-1ubuntu1.14.04.1_amd64.deb
              rm -fr powershell_6.0.0-alpha.15-1ubuntu1.14.04.1_amd64.deb
              sudo apt-get install -f
              ;;
            16.04)
              curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
              curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
              sudo apt-get update
              sudo apt-get install -y powershell
              ;;
          esac
          ;;
      esac
      ;;
  esac
}
if ! type -p powershell >/dev/null; then get-powershell; fi
