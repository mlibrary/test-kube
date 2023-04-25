(import 'web-plus-database/web-plus-database.libsonnet') +
{
  _config+:: {
    fqdn: 'blog.test.kubernetes.lib.umich.edu',
    secrets: [
      import './db.json',
      import './ghost.json',
    ],
  }
}
