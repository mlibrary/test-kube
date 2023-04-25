(import 'app-of-apps/app-of-apps.libsonnet') +
{
  _config+:: {
    cluster_name: 'production',
    kube_common_branch: 'stable',
  },
}
