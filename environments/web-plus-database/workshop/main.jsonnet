(import 'web-plus-database/web-plus-database.libsonnet') +
{
  _config+:: {
    fqdn: 'fakeblog.test.kubernetes.lib.umich.edu',
    secrets: [
      import './db.json',
      import './ghost.json',
    ],
  },

  test_storage: {
    test_storage: {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: 'test-storage',
      },
    },
    pre_puppet_1_pvc: {
      kind: 'PersistentVolumeClaim',
      apiVersion: 'v1',
      metadata: {
        name: 'pre-puppet-1-pvc',
        namespace: 'default',
      },
      spec: {
        accessModes: [
          'ReadWriteOnce',
        ],
        storageClassName: 'local-storage',
        resources: {
          requests: {
            storage: '50Mi',
          },
        },
      },
    },
    pre_puppet_2_pvc: {
      kind: 'PersistentVolumeClaim',
      apiVersion: 'v1',
      metadata: {
        name: 'pre-puppet-2-pvc',
        namespace: 'default',
      },
      spec: {
        accessModes: [
          'ReadWriteOnce',
        ],
        storageClassName: 'local-storage',
        resources: {
          requests: {
            storage: '50Mi',
          },
        },
      },
    },
    pre_puppet_3_pvc: {
      kind: 'PersistentVolumeClaim',
      apiVersion: 'v1',
      metadata: {
        name: 'pre-puppet-3-pvc',
        namespace: 'default',
      },
      spec: {
        accessModes: [
          'ReadWriteOnce',
        ],
        storageClassName: 'local-storage',
        resources: {
          requests: {
            storage: '50Mi',
          },
        },
      },
    },
    post_puppet_1_pvc: {
      kind: 'PersistentVolumeClaim',
      apiVersion: 'v1',
      metadata: {
        name: 'post-puppet-1-pvc',
        namespace: 'test-storage',
      },
      spec: {
        accessModes: [
          'ReadWriteOnce',
        ],
        storageClassName: 'local-storage',
        resources: {
          requests: {
            storage: '50Mi',
          },
        },
      },
    },
    post_puppet_2_pvc: {
      kind: 'PersistentVolumeClaim',
      apiVersion: 'v1',
      metadata: {
        name: 'post-puppet-2-pvc',
        namespace: 'test-storage',
      },
      spec: {
        accessModes: [
          'ReadWriteOnce',
        ],
        storageClassName: 'local-storage',
        resources: {
          requests: {
            storage: '50Mi',
          },
        },
      },
    },
    post_puppet_3_pvc: {
      kind: 'PersistentVolumeClaim',
      apiVersion: 'v1',
      metadata: {
        name: 'post-puppet-3-pvc',
        namespace: 'test-storage',
      },
      spec: {
        accessModes: [
          'ReadWriteOnce',
        ],
        storageClassName: 'local-storage',
        resources: {
          requests: {
            storage: '50Mi',
          },
        },
      },
    },
  },
}
