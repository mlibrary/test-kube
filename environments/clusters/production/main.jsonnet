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
          value: 'environments/clusters/production',
        }] },
      },
    },
  },

  argocd: self.app_of_apps + {
    metadata+: { name: 'argocd-with-tanka' },
    spec+: {
      source+: {
        repoURL: 'https://github.com/mlibrary/kube-common',
        targetRevision: 'stable',
        plugin: { env: [{
          name: 'TANKA_PATH',
          value: 'environments/argocd-with-tanka',
        }]},
      },
    },
  },

  sealed_secrets: {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'sealed-secrets',
      labels: { 'argocd.argoproj.io/instance': 'app-of-apps' },
    },
    spec: {
      project: 'default',
      syncPolicy: { automated: { } },
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: 'kube-system',
      },
      source: {
        repoURL: 'https://bitnami-labs.github.io/sealed-secrets',
        targetRevision: '^2.7.0',
        chart: 'sealed-secrets',
        helm: { releaseName: 'sealed-secrets-controller' },
      },
    },
  },

  web_plus_database: self.app_of_apps + {
    metadata+: { name: 'web-plus-database' },
    spec+: { source+: {
      plugin: { env: [{
        name: 'TANKA_PATH',
        value: 'environments/web-plus-database/production',
      }]},
    }},
  },
}
