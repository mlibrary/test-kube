{
  namespace: {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
  },
}
