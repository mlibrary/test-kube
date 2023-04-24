{
  app_of_apps: {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'app-of-apps',
      labels: { 'argocd.argoproj.io/instance': 'app-of-apps' },
    },
    spec: {
      project: 'default',
      destination: { server: 'https://kubernetes.default.svc' },
      syncPolicy: { automated: { prune: true, selfHeal: true } },
      source: {
        repoURL: 'https://github.com/mlibrary/test-kube',
        targetRevision: 'HEAD',
        path: '.',
        plugin: { env: [{
          name: 'TANKA_PATH',
          value: 'environments/clusters/workshop',
        }] },
      },
    },
  },

  argocd: self.app_of_apps + {
    metadata+: { name: 'argocd-with-tanka' },
    spec+: {
      source+: {
        repoURL: 'https://github.com/mlibrary/kube-common',
        targetRevision: 'latest',
        plugin: { env: [{
          name: 'TANKA_PATH',
          value: 'environments/argocd-with-tanka',
        }]},
      },
    },
  },
}
