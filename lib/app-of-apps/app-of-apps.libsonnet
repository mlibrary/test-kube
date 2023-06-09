(import './common.libsonnet') + {
  _config+:: {
    cluster_name: error 'must provide $._config.cluster_name',
  },

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
          value: 'environments/clusters/%s' % $._config.cluster_name,
        }] },
      },
    },
  },

  web_plus_database: self.app_of_apps + {
    metadata+: { name: 'web-plus-database' },
    spec+: { source+: {
      plugin: { env: [{
        name: 'TANKA_PATH',
        value: 'environments/web-plus-database/%s' % $._config.cluster_name,
      }]},
    }},
  },
}
