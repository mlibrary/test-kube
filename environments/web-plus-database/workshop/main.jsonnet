(import 'web-plus-database/web-plus-database.libsonnet') +
{
  _config+:: {
    fqdn: 'fakeblog.test.kubernetes.lib.umich.edu',
    secrets: [
      import './db.json',
      import './ghost.json',
    ],
  },

  'rook-bug': {
    namespace: {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: 'rook-bug',
        labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
      },
    },
    'pod-a': {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: 'pod-a',
        namespace: 'rook-bug',
        labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
      },
      spec: {
        replicas: 1,
        selector: { matchLabels: {
          'app.kubernetes.io/name': 'pod-a',
          'app.kubernetes.io/part-of': 'rook-bug',
        } },
        template: {
          metadata: { labels: {
            'app.kubernetes.io/name': 'pod-a',
            'app.kubernetes.io/part-of': 'rook-bug',
          } },
          spec: {
            volumes: [
              {
                name: 'rw-many',
                persistentVolumeClaim: {
                  claimName: 'rw-many',
                },
              },
            ],
            containers: [
              {
                name: 'pod-a',
                image: 'busybox:latest',
                volumeMounts: [
                  {
                    name: 'rw-many',
                    mountPath: '/opt/test',
                  },
                ],
              },
            ],
          },
        },
      },
    },
    'pod-b': {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: 'pod-b',
        namespace: 'rook-bug',
        labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
      },
      spec: {
        replicas: 1,
        selector: { matchLabels: {
          'app.kubernetes.io/name': 'pod-b',
          'app.kubernetes.io/part-of': 'rook-bug',
        } },
        template: {
          metadata: { labels: {
            'app.kubernetes.io/name': 'pod-b',
            'app.kubernetes.io/part-of': 'rook-bug',
          } },
          spec: {
            volumes: [
              {
                name: 'rw-many',
                persistentVolumeClaim: {
                  claimName: 'rw-many',
                },
              },
            ],
            containers: [
              {
                name: 'pod-b',
                image: 'busybox:latest',
                volumeMounts: [
                  {
                    name: 'rw-many',
                    mountPath: '/opt/test',
                  },
                ],
              },
            ],
          },
        },
      },
    },
    'rw-many': {
      apiVersion: 'v1',
      kind: 'PersistentVolumeClaim',
      metadata: {
        name: 'rw-many',
        namespace: 'rook-bug',
        labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
      },
      spec: {
        accessModes: ['ReadWriteOnce'],
        resources: { requests: { storage: '25Mi' } },
      },
    },
  },
}
