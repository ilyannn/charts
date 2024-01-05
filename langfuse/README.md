# Experimental Langfuse chart

See [values.yaml](values.yaml) for the chart values. They are subject to change!

## Installation

```shell
helm install langfuse-demo https://github.com/ilyannn/charts/releases/download/langfuse-v0.2.0/langfuse-0.2.0.tgz -f langfuse-values.yaml
```


### Using Existing Database Connection

By default, the bundled database is disabled so a connection URL is required.

```yaml
databaseURL: "postgresql://some-existing-url"
```

The alternative format of `DATABASE_HOST` etc. can be used in the additional options below.


### Using Bundled Postgres

With the bundled Postgres enabled, the chart takes care of installing it and setting up authentication.

```yaml
postgresql:
  enabled: true
```

The password will be generated and saved in a `Secret` (in this case, named `langfuse-demo-postgres-secret`).


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
...
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
