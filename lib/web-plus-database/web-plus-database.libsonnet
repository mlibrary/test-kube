{
  _config+:: {
    fqdn: error 'must provide $._config.fqdn',
    secrets: [],
  },

  secrets: [x + { metadata+: { labels+: {
    'argocd.argoproj.io/instance': 'web-plus-database'
  }}} for x in $._config.secrets],

  namespace: {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
  },

  web: {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'web',
      namespace: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
    spec: {
      replicas: 1,
      selector: { matchLabels: {
        'app.kubernetes.io/name': 'web',
        'app.kubernetes.io/part-of': 'ghost',
      } },
      template: {
        metadata: { labels: {
          'app.kubernetes.io/name': 'web',
          'app.kubernetes.io/component': 'server',
          'app.kubernetes.io/part-of': 'ghost',
        } },
        spec: { containers: [{
          name: 'web',
          image: 'ghost:latest',
          ports: [{ containerPort: 2368 }],
          env: [{
            name: 'database__client',
            value: 'mysql',
          }, {
            name: 'database__connection__host',
            value: 'db',
          }, {
            name: 'database__connection__user',
            valueFrom: { secretKeyRef: {
              name: 'db',
              key: 'database__connection__user',
            }}
          }, {
            name: 'database__connection__password',
            valueFrom: { secretKeyRef: {
              name: 'db',
              key: 'database__connection__password',
            }}
          }, {
            name: 'database__connection__database',
            value: 'ghost',
          }, {
            name: 'url',
            value: 'https://%s' % $._config.fqdn,
          }],
        }] },
      },
    },
  },

  db: {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'db',
      namespace: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
    spec: {
      replicas: 1,
      strategy: { type: 'Recreate' },
      selector: { matchLabels: {
        'app.kubernetes.io/name': 'db',
        'app.kubernetes.io/part-of': 'ghost',
      } },
      template: {
        metadata: { labels: {
          'app.kubernetes.io/name': 'db',
          'app.kubernetes.io/component': 'database',
          'app.kubernetes.io/part-of': 'ghost',
        } },
        spec: {
          containers: [{
            name: 'db',
            image: 'mariadb:10.8',
            ports: [{ containerPort: 3306 }],
            env: [{
              name: 'MYSQL_ROOT_PASSWORD',
              valueFrom: { secretKeyRef: {
                name: 'db',
                key: 'MYSQL_ROOT_PASSWORD',
              }}
            }],
            volumeMounts: [{
              name: 'db',
              mountPath: '/var/lib/mysql',
            }],
          }],
          volumes: [{
            name: 'db',
            persistentVolumeClaim: { claimName: 'db' },
          }],
        },
      },
    },
  },

  web_service: {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'web',
      namespace: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
    spec: {
      type: 'ClusterIP',
      ports: [{ port: 80, targetPort: 2368 }],
      selector: {
        'app.kubernetes.io/component': 'server',
        'app.kubernetes.io/part-of': 'ghost',
      },
    },
  },

  db_service: {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'db',
      namespace: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
    spec: {
      type: 'ClusterIP',
      ports: [{ port: 3306 }],
      selector: {
        'app.kubernetes.io/component': 'database',
        'app.kubernetes.io/part-of': 'ghost',
      },
    },
  },

  ingress: {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: 'web',
      namespace: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
      annotations: {
        'cert-manager.io/cluster-issuer': 'letsencrypt',
      },
    },
    spec: {
      tls: [{
        secretName: 'web-tls',
        hosts: [$._config.fqdn],
      }],
      rules: [{
        host: $._config.fqdn,
        http: { paths: [{
          path: '/',
          pathType: 'Prefix',
          backend: { service: {
            name: 'web',
            port: { number: 80 },
          } },
        }] },
      }],
    },
  },

  pvc: {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: 'db',
      namespace: 'ghost',
      labels: { 'argocd.argoproj.io/instance': 'web-plus-database' },
    },
    spec: {
      accessModes: ['ReadWriteOnce'],
      resources: { requests: { storage: '1G' } },
    },
  },
}
