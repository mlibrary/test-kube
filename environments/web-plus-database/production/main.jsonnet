{
  secrets: [
    (import './db.json') + { metadata+: { labels+: {
      'argocd.argoproj.io/instance': 'web-plus-database'
    }}},
    (import './ghost.json') + { metadata+: { labels+: {
      'argocd.argoproj.io/instance': 'web-plus-database'
    }}},
  ],

  namespace: {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
  },
}
