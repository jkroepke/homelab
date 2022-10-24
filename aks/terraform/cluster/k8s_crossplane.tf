/*

---
apiVersion: v1
kind: Secret
metadata:
  name: azure-account-creds
  namespace: infra-crossplane
type: Opaque
data:
  credentials: ${BASE64ENCODED_AZURE_ACCOUNT_CREDS}
*/


resource "kubernetes_namespace" "infra-crossplane" {
  metadata {
    name = "infra-crossplane"
  }
}
