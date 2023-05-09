{
  _config+:: {
    kube_common_branch: error 'must provide $._config.kube_common_branch',
  },

  argocd: {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'argocd-with-tanka',
      labels: { 'argocd.argoproj.io/instance': 'app-of-apps' },
    },
    spec: {
      project: 'default',
      destination: { server: 'https://kubernetes.default.svc' },
      syncPolicy: { automated: { prune: true, selfHeal: true } },
      source: {
        repoURL: 'https://github.com/mlibrary/kube-common',
        targetRevision: $._config.kube_common_branch,
        path: '.',
        plugin: { env: [{
          name: 'TANKA_PATH',
          value: 'environments/argocd-with-tanka',
        }] },
      },
    },
  },

  sealed_secrets: self.argocd + {
    metadata+: { name: 'sealed-secrets-common' },
    spec+: { source+: {
      plugin: { env: [{
        name: 'TANKA_PATH',
        value: 'environments/sealed-secrets',
      }]},
    }},
  },
}
