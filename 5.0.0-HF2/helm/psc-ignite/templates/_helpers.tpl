{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "psc-ignite.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "psc-ignite.labels" -}}
helm.sh/chart: {{ include "psc-ignite.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "psc-ignite.selectorLabels" . }}
{{- end }}

{{/*
Ignite selector labels
*/}}
{{- define "psc-ignite.selectorLabels" -}}
app: {{ .Values.app.name }}
tier: ignite
{{- end }}
