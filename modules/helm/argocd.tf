resource "helm_release" "argocd" {

  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.50.1"
  namespace  = "argocd"
  create_namespace = true 
  }


resource "helm_release" "root_app" {

  name       = "root-app"
  chart      = "../../modules/helm/root_chart"
  version    = "0.1.0"
  depends_on = [helm_release.argocd]
   }