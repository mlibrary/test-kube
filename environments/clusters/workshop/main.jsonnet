(import 'app-of-apps/app-of-apps.libsonnet') +
{
  _config+:: {
    cluster_name: 'workshop',
    kube_common_branch: 'latest',
  },
}
