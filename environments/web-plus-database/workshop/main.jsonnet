(import 'web-plus-database/web-plus-database.libsonnet') +
{
  _config+:: {
    fqdn: 'fakeblog.test.kubernetes.lib.umich.edu',
    secrets: [
      import './db.json',
      import './ghost.json',
    ],
  },

  db+: {
    spec+: {
      template+: {
        spec+: {
          volumes: [{
            name: 'db',
            persistentVolumeClaim: { claimName: 'db-vol' },
          }],
        },
      },
    },
  },
  pvc+: {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: 'db-vol',
      namespace: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
    spec: {
      accessModes: ['ReadWriteOncePod'],
      resources: { requests: { storage: '1G' } },
      dataSource: {
        kind: 'PersistentVolumeClaim',
        name: 'db',
      },
    },
  },
}
