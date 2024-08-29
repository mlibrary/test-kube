(import 'web-plus-database/web-plus-database.libsonnet') +
{
  _config+:: {
    fqdn: 'blog.test.kubernetes.lib.umich.edu',
    secrets: [
      import './db.json',
      import './ghost.json',
    ],
  },
/*
  db+: {
    spec+: {
      template+: {
        spec+: {
          volumes: [{
            name: 'db',
            persistentVolumeClaim: { claimName: 'db-pvc' },
          }],
        },
      },
    },
  },

  pvc+: {
    metadata+: {
      name: 'db-pvc',
    },
    spec+: {
      accessModes: ['ReadWriteOncePod'],
      dataSource: {
        kind: 'PersistentVolumeClaim',
        name: 'db',
      },
    },
  },
  */
}
