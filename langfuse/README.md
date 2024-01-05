# Experimental Langfuse chart

See [values.yaml](values.yaml) for the chart values. They are subject to change!

## Installation

Example installation:

```shell
helm install langfuse-demo https://github.com/ilyannn/charts/releases/download/langfuse-v0.2.0/langfuse-0.2.0.tgz -f langfuse-values.yaml
```

### Default Installation

By default, Langfuse will be installed with the bundled Postgres.

The password will be generated and saved in a `Secret` (in this case, `langfuse-demo-postgres-secret`).


### OAuth 

### Using Existing Database Connection

Disable the bundled database and pass an exising connection URL instead.

```yaml
databaseURL: "postgresql://some-existing-url"

postgresql:
  enabled: false
```


### Accessing the installation

The chart comes with an ingress that can be set up with

```yaml
ingress:
  enabled: true
  hosts: ...
```


### Uninstalling


The usual `helm uninstall RELEASE_NAME` should work, but note that the following objects are not deleted automatically:

- the data PVC of the `postgres` subchart (if the subchart was enabled)
- the `-postgres-secret` secret (unless `postgresql.secret.alwaysKeepWhenUninstalled` is unset)

This means that you can reinstall the chart and continue accessing the same data. 


### Example values

See [megaver.se demo](https://docs.cluster.megaver.se/cluster/langfuse-demo-values.yaml)
