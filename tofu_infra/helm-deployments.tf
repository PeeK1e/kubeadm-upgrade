data "template_file" "cilium-values" {
  template = file("helm/cilium.yaml")
  vars = {
    cluster_address = hcloud_rdns.rdns-lb.dns_ptr
  }

  depends_on = [hcloud_rdns.rdns-lb]
}

resource "helm_release" "cilium" {
  name      = "cilium"
  chart     = "cilium"
  namespace = "kube-system"

  repository = "https://helm.cilium.io/"
  version    = "1.14.9"

  values = [data.template_file.cilium-values.rendered]

  depends_on = [
    local_file.kubeconfig,
    ssh_resource.join_command,
    ssh_resource.certificate,
    ssh_resource.join-cp,
    ssh_resource.join-worker
  ]
}

resource "helm_release" "nginx" {
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  namespace        = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.9.1"

  values = ["${file("helm/nginx-ingress.yaml")}"]

  depends_on = [helm_release.cilium]
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  create_namespace = true
  namespace        = "cert-manager"

  repository = "https://charts.jetstack.io"
  version    = "1.14.5"

  depends_on = [helm_release.cilium]

  values = [
    <<EOF
installCRDs: true
strategy:
  rollingUpdate:
    maxSurge: 3
    maxUnavailable: 1
  type: RollingUpdate
EOF
  ]
}

resource "kubectl_manifest" "clusterissuer-letsencrypt" {
  apply_only       = true
  wait_for_rollout = false
  yaml_body        = <<-YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: void@void.eu
    preferredChain: ""
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: nginx
YAML

  depends_on = [helm_release.cert-manager]
}

resource "kubectl_manifest" "hcloud-csi-token" {
  yaml_body = <<-YAML
# secret.yml
apiVersion: v1
kind: Secret
metadata:
  name: hcloud
  namespace: kube-system
stringData:
  token: "${var.hcloud_token}"
YAML

  depends_on = [helm_release.cilium]
}

resource "helm_release" "hcloud-csi" {
  name             = "hcloud-csi-provider"
  chart            = "hcloud-csi"
  create_namespace = true
  namespace        = "kube-system"

  repository = "https://charts.hetzner.cloud"
  version    = "2.8.0"

  #values = ["${file("helm/nginx-ingress.yaml")}"]

  depends_on = [
    helm_release.cilium,
    kubectl_manifest.hcloud-csi-token
  ]
}
