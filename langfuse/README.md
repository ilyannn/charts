# Experimental Langfuse chart

See [values.yaml](values.yaml) for the chart values. They are subject to change!

## Installation

Example installation:

```shell
helm install langfuse-demo https://github.com/ilyannn/charts/langfuse -f values.yaml
```

### Default Installation

With the default values, Langfuse will be installed with the bundled Postgres.
The password will be generated and saved in a secret (in this case, `langfuse-demo-postgres-secret`) 


### Connecting existing Postgres instance

You can pass the exising connection URL.

```yaml
databaseURL: "postgresql://some-existing-url"

postgresql:
  enabled: false
```
