resource "helm_release" "argocd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.50.1"
  namespace        = "argocd"
  create_namespace = true
  values           = [file("../../modules/helm/repositories.yaml")]

}


resource "helm_release" "argocd-root-app" {
  depends_on       = [helm_release.argocd]
  name             = "argocd-root-app"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  version          = "1.6.2"
  namespace        = "argocd"
  create_namespace = true
  values = [
    templatefile("../../modules/helm/root.yaml", { app_path = "${var.app_path}" })
  ]
}


resource "helm_release" "argocd-image-updater" {
  depends_on       = [helm_release.argocd-root-app]
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  version          = "0.9.4"
  create_namespace = true
  namespace        = "argocd"
  values           = [file("../../modules/helm/image_updater.yaml")] # Reference the values file
}
