# #
# # CHEATSHEET
# #
# # 1. Initialize
# gcloud init
#
# # 2. Login
# gcloud auth login
#
# # 3. Setup project_id
# gcloud config set project $project_id
#
GCLOUD_PROJECT_ID='utagaki-v2'
PATH="$HOME/google-cloud-sdk/bin:$PATH"
export CLOUDSDK_PYTHON=/usr/bin/python

get-gcloud() {
  case "${OSTYPE}" in
    cygwin | darwin* | linux*)
      curl https://sdk.cloud.google.com | bash
      exec -l $SHELL
      ;;
  esac
}

set-gcloud() {
  case "${OSTYPE}" in
    cygwin | darwin* | linux*)
      source ~/google-cloud-sdk/completion.zsh.inc
      source ~/google-cloud-sdk/path.zsh.inc
      source ~/google-cloud-sdk/completion.zsh.inc
      gcloud config set project $GCLOUD_PROJECT_ID
      ;;
  esac
}

gcloud-init() {
  gcloud init
}

if ! type -p gcloud >/dev/null; then get-gcloud; fi
if type -p gcloud >/dev/null; then set-gcloud; fi

# ----------------------------------------------------------------------
# GoogleCloudPubsub
gcloud-pubsub-init() {
  eval $(gcloud beta emulators pubsub env-init)
}

gcloud-pubsub-status() {
  echo $PUBSUB_EMULATOR_HOST
  ps aux | grep [p]ubsub
}

gcloud-pubsub-start() {
  nohup gcloud beta emulators pubsub start >~/.config/gcloud/logs/gcloud-pubsub.log 2>&1 &
  gcloud-pubsub-init
  gcloud-pubsub-status
}

gcloud-pubsub-stop() {
  for i in $(ps aux | grep [p]ubsub | awk '{print $2}'); do
    if [ $i -gt 0 ]; then
      sudo kill -9 $i
    fi
  done
}

gcloud-pubsub-restart() {
  gcloud-pubsub-stop
  gcloud-pubsub-start
}

gcloud-pubsub-log() {
  tailf ~/.config/gcloud/logs/gcloud-pubsub.log
}

alias gcpt=gcloud-pubsub-stop
alias gcpk=gcloud-pubsub-stop
alias gcpr=gcloud-pubsub-restart
alias gcpl=gcloud-pubsub-log
alias gcps=gcloud-pubsub-status
alias gcpp=gcloud-pubsub-status
