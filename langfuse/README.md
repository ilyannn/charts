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

If the bundled chart is disabled, one can authenticate to an existing database.

```yaml
postgresql:
  enabled: false

databaseURL: "postgresql://some-existing-url"
```

### Accessing the installation

The chart comes with an ingress that can be set up with

```yaml
ingress:
  enabled: true
  hosts: ...
```

### Additional options

Any options not present in the [values file](values.yaml) can be put into a `Secret` to be passed to Langfuse:

```yaml
additionalConfigurationSecret: langfuse-additional-options
```

You can create and update the secret at any time as it will not be managed by Helm.

```shell
kubectl create secret generic langfuse-additional-options \
  --from-literal=AUTH_GITHUB_CLIENT_ID=... \
  --from-literal=AUTH_GITHUB_CLIENT_SECRET=...
```

## Uninstalling

The usual `helm uninstall RELEASE_NAME` should work, but note that the following objects are not deleted automatically:

- the data PVC of the `postgres` subchart (if the subchart was enabled)
- the `-postgres-secret` secret (unless `postgresql.secret.alwaysKeepWhenUninstalled` is unset)
- the `-internal-secret` secret

This means that you can reinstall the chart and continue accessing the same data.

## Example values

See [megaver.se demo](https://docs.cluster.megaver.se/cluster/langfuse-demo-values.yaml)
