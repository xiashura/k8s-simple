
with (import <nixpkgs> {});

stdenv.mkDerivation {

  KUBECONFIG = "/home/xi/Projects/devops/k8s-simple/admin.conf";

  name = "k8s-simple";
  buildInputs = [
    terraform
    kubectl
    kind
    kubernetes-helm-wrapped
    hubble
    cilium-cli
    vault-bin
    jq
  ];
}