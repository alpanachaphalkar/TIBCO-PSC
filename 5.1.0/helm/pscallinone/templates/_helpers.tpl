{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "psc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
PSC labels
*/}}
{{- define "psc.labels" -}}
helm.sh/chart: {{ include "psc.chart" . }}
{{ include "psc.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
PSC Selector labels
*/}}
{{- define "psc.selectorLabels" -}}
app: {{ .Values.app.name }}
version: {{ .Chart.AppVersion }}
{{- end }}
