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
    podA: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: 'podA',
        namespace: 'rook-bug',
        labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
      },
      spec: {
        replicas: 1,
        selector: { matchLabels: {
          'app.kubernetes.io/name': 'podA',
          'app.kubernetes.io/part-of': 'rook-bug',
        } },
        template: {
          metadata: { labels: {
            'app.kubernetes.io/name': 'podA',
            'app.kubernetes.io/part-of': 'rook-bug',
          } },
          spec: {
            volumes: [
              {
                name: 'rwMany',
                persistentVolumeClaim: {
                  claimName: 'rwMany',
                },
              },
            ],
            containers: [
              {
                name: 'podA',
                image: 'busybox:latest',
                volumeMounts: [
                  {
                    name: 'rwMany',
                    mountPath: '/opt/test',
                  },
                ],
              },
            ],
          },
        },
      },
    },
    podB: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: 'podB',
        namespace: 'rook-bug',
        labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
      },
      spec: {
        replicas: 1,
        selector: { matchLabels: {
          'app.kubernetes.io/name': 'podB',
          'app.kubernetes.io/part-of': 'rook-bug',
        } },
        template: {
          metadata: { labels: {
            'app.kubernetes.io/name': 'podB',
            'app.kubernetes.io/part-of': 'rook-bug',
          } },
          spec: {
            volumes: [
              {
                name: 'rwMany',
                persistentVolumeClaim: {
                  claimName: 'rwMany',
                },
              },
            ],
            containers: [
              {
                name: 'podB',
                image: 'busybox:latest',
                volumeMounts: [
                  {
                    name: 'rwMany',
                    mountPath: '/opt/test',
                  },
                ],
              },
            ],
          },
        },
      },
    },
    rwMany: {
      apiVersion: 'v1',
      kind: 'PersistentVolumeClaim',
      metadata: {
        name: 'rwMany',
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
