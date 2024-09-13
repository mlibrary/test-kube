(import 'app-of-apps/app-of-apps.libsonnet') +
{
  _config+:: {
    cluster_name: 'workshop',
    kube_common_branch: 'latest',
  },

  prometheus_application: {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: { name: 'prometheus' },
    spec: {
      project: 'default',
      destination: { server: 'https://kubernetes.default.svc' },
      syncPolicy: { automated: { prune: true, selfHeal: true } },
      source: {
        repoURL: 'https://github.com/mlibrary/kube-common',
        targetRevision: 'latest', // or 'stable' if you want slower updates
        path: '.',
        plugin: { env: [{
          name: 'TANKA_PATH',
          value: 'environments/prometheus',
        }]},
      },
    },
  },

  prometheus_config: {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'monitoring-rules',
      namespace: 'prometheus',
    },
    data: {
      'alerts.yml': std.manifestYamlDoc({
        // Your alerts go here
      }),
    },
  },

  global_prometheus_application: {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: { name: 'global-prometheus' },
    spec: {
      project: 'default',
      destination: { server: 'https://kubernetes.default.svc' },
      syncPolicy: { automated: { prune: true, selfHeal: true } },
      source: {
        repoURL: 'https://github.com/mlibrary/kube-common',
        targetRevision: 'latest', // or 'stable' if you want slower updates
        path: '.',
        plugin: { env: [{
          name: 'TANKA_PATH',
          value: 'environments/global-prometheus',
        }]},
      },
    },
  },

  global_prometheus_config: {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'monitoring-rules',
      namespace: 'global-prometheus',
    },
    data: {
      'alerts.yml': std.manifestYamlDoc({
        // Your alerts go here
      }),
      'scrape-configs.yml': std.manifestYamlDoc({
        scrape_configs: [
          // Your additional scrape target configs go here
        ]
      }),
    },
  },
}
