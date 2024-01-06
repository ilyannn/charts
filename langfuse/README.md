# Experimental Langfuse chart

See [values.yaml](values.yaml) for the chart values. They are subject to change!

## Installation

```shell
helm install langfuse-demo https://ilyannn.github.io/charts/langfuse -f langfuse-values.yaml
```

### Config-Free Installation

The default values set up the bundled Postgres, and the chart takes care of and setting up
the authentication between the database and the service.

The Postgres password will be generated and saved in a `Secret` (in the example above, named
`langfuse-demo-postgres-secret`).

### Connecting to an Existing Database

If the bundled chart is disabled, one can authenticate to an existing database using the `databaseURL` value:

```yaml
postgresql:
  enabled: false

databaseURL: "postgresql://some-existing-url"
```

### Accessing the Installation

The chart comes with an ingress that can be set up with

```yaml
ingress:
  enabled: true
  hosts: ...
  tls: ...
```

### Additional Options

Any options not available in the [values file](values.yaml) can be manually put into a `Secret` and passed in the `secrets.additional` value:

```yaml
secrets:
  additional:
    - my-github-options
    - my-google-options
    - ...
```

You should create the secrets before installing the chart:

```shell
kubectl create secret generic my-github-options \
  --from-literal=AUTH_GITHUB_CLIENT_ID=... \
  --from-literal=AUTH_GITHUB_CLIENT_SECRET=...
```

This can also be used to avoid providing `databaseURL` in plaintext:

```yaml
postgresql:
  enabled: false

secrets:
  additional:
    - my-postgres-connection # field name is DATABASE_URL
```

## Notes on Uninstalling

The usual `helm uninstall RELEASE_NAME` should work,
but note that the following objects are not deleted automatically with the default values:

- the data PVC of the `postgres` subchart (if the subchart was enabled)
- the `-postgres-secret` secret (if the subchart was enabled, controlled by `secrets.postgresql.keepWhenUninstalled`)
- the `-internal-secret` secret (controlled by `secrets.internal.keepWhenUninstalled`)

This means that you can reinstall the chart and continue accessing the same data.

## Example Value Chart

See [megaver.se demo](https://docs.cluster.megaver.se/cluster/langfuse-demo-values.yaml)
