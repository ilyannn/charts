{{/*
Expand the name of the chart.
*/}}
{{- define "langfuse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "langfuse.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "langfuse.connectionSecret" -}}
{{- printf "%s-%s" (include "langfuse.fullname" .) "connection-secret" -}}
{{- end }}

{{- define "langfuse.internalSecret" -}}
    {{- printf "%s" (tpl .Values.secrets.internal.name $) -}}
{{- end }}

{{- define "langfuse.internalSecret.annotations" -}}
{{- if .Values.secrets.internal.keepWhenUninstalled -}}
    "helm.sh/resource-policy": "keep"
{{- end }}
{{- end }}

{{- define "langfuse.postgresqlSecret" -}}
    {{- printf "%s" (tpl .Values.postgresql.auth.existingSecret $) -}}
{{- end }}

{{- define "langfuse.postgresqlSecret.annotations" -}}
{{- if .Values.secrets.postgres.keepWhenUninstalled -}}
    "helm.sh/resource-policy": "keep"
{{- end }}
{{- end }}

{{- define "langfuse.additionalSecrets" -}}
          {{- range .Values.secrets.additional }}
            - secretRef:
                name: {{ . }}
          {{- end }}
{{- end }}

 
{{- define "langfuse.databaseHost" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s.%s.%s" 
    (include "postgresql.v1.primary.fullname" .Subcharts.postgresql) 
    .Release.Namespace
    "svc.cluster.local" -}}
{{- end }}
{{- end }}

{{- define "langfuse.configMap" -}}
{{- printf "%s-%s" (include "langfuse.fullname" .) "config-map" -}}
{{- end }}

{{- define "langfuse.databaseName" -}}
{{- printf "%s" (tpl .Values.postgresql.auth.database .) -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "langfuse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "langfuse.labels" -}}
helm.sh/chart: {{ include "langfuse.chart" . }}
{{ include "langfuse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "langfuse.selectorLabels" -}}
app.kubernetes.io/name: {{ include "langfuse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "langfuse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "langfuse.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a dictionary with keys and random values
*/}}
{{- define "langfuse.createRandomValuesForKeys" -}}
  {{- $result := dict -}}
  {{- range . -}}
    {{- $_ := set $result . (randAlphaNum 50 | b64enc) -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}

{{/*
Add random values to all missing keys of a dictionary

Usage:
   include "langfuse.addRandomValuesForKeys" (dict "keys" (list "key1" "key2") "source" $originalDictionary) "indent" 4

*/}}
{{- define "langfuse.addRandomValuesForKeys" -}}
  {{- $source := .source }}
  {{- $indent := .indent }}
  {{- range .keys -}} 
  {{- $v := get $source . | default (randAlphaNum 100 | b64enc) -}}
  {{- . | nindent $indent}} : {{ $v | quote }}
  {{- end -}}
{{- end -}}


{{/*
Defines a secret that fills missing fields with random values

Usage:
   include "langfuse.mergeSecretWithRandomForKeys" (dict 
        "name" "someSecretName" 
        "annotations" (dict "a" "b")
        "keys" (list "key1" "key2") 
        "context" .
   )
   
*/}}
{{- define "langfuse.mergeSecretWithRandomForKeys" -}}
{{- $existingData := lookup "v1" "Secret" .context.Release.Namespace .name | dig "data" dict -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .name }}
  {{- if .annotations }}
  annotations: 
    {{- .annotations | nindent 4 }}
  {{- end }}
type: Opaque
data:
{{- include "langfuse.addRandomValuesForKeys" (dict 
    "keys" .keys 
    "source" $existingData 
    "indent" 2
  ) -}}
{{- end -}}
