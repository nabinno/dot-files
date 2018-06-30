export REQUIRED_OCAML_VERSION=4.02.3+buckle-1
export REQUIRED_COQ_VERSION=8.7.2

get-ocaml() {
  asdf install ocaml $REQUIRED_OCAML_VERSION
  asdf global ocaml $REQUIRED_OCAML_VERSION
  get-global-opam-packages
}

get-ocaml-by-ocamlbrew() {
  curl -kL https://raw.github.com/hcarty/ocamlbrew/master/ocamlbrew-install | bash
  source ~/ocamlbrew/ocaml-*/etc/ocamlbrew.bashrc
  opam switch $REQUIRED_OCAML_VERSION
  eval $(opam config env)
  get-global-opam-packages
}
if ! type -p ocaml >/dev/null; then get-ocaml; fi

get-global-opam-packages() {
  opam install \
    core_kernel \
    core \
    ounit \
    utop \
    tuareg \
    reason \
    merlin
}

get-global-npm-packages-for-ocaml() {
  npm i -g \
    ocaml-language-server
}

# ----------------------------------------------------------------------
# Coq
get-coq() {
  nix-install coq
}

get-coq-by-asdf() {
  asdf install coq $REQUIRED_COQ_VERSION
  asdf global coq $REQUIRED_COQ_VERSION
}
