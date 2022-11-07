resource "kind_cluster" "k8s-simple" {
  name            = "k8s-simple"
  wait_for_ready  = true
  kubeconfig_path = "${path.root}/admin.conf"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    node {
      role = "worker"
    }
    node {
      role = "worker"
    }

    networking {
      disable_default_cni = "true"
      pod_subnet          = "10.10.0.0/16"
      service_subnet      = "10.11.0.0/16"
    }
  }
}

resource "null_resource" "kubernetes_setup_for_ready" {
  depends_on = [
    kind_cluster.k8s-simple
  ]
  provisioner "local-exec" {
    command = <<EOF
    export all_nodes=$(
   	kubectl get nodes \
   	-o custom-columns=NAME:.metadata.name \
   	| tail -n +2)	&&  
   	kubectl taint node $all_nodes \
   	node.kubernetes.io/not-ready:NoSchedule-
    EOF
  }

}


resource "helm_release" "cni" {
  depends_on = [
    kind_cluster.k8s-simple,
    null_resource.kubernetes_setup_for_ready
  ]

  name       = "cilium"
  chart      = "cilium"
  repository = "https://helm.cilium.io/"
  version    = "1.9.18"

  namespace = "kube-system"

  values = [
    "nodeinit.enabled: true",
    "kubeProxyReplacement: partial",
    "hostServices.enabled: false",
    "externalIPs.enabled: true",
    "nodePort.enabled: true",
    "hostPort.enabled: true",
    "bpf.masquerade: false",
    "image.pullPolicy: IfNotPresent",
    "ipam.mode: kubernetes",
    "hubble.listenAddress: ':4244'",
    "hubble.relay.enabled: true",
    "hubble.ui.enabled: true",
  ]
}

