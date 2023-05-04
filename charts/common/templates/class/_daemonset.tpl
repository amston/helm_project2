{{/* DaemonSet Class */}}
{{/* Call this template:
{{ include "tc.v1.common.class.deployment" (dict "rootCtx" $ "objectData" $objectData) }}

rootCtx: The root context of the chart.
objectData: The object data to be used to render the DaemonSet.
*/}}

{{- define "tc.v1.common.class.daemonset" -}}

  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}
  {{- include "tc.v1.common.lib.workload.daemonsetValidation" (dict "objectData" $objectData) }}
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: {{ $objectData.name }}
  {{- $labels := (mustMerge ($objectData.labels | default dict) (include "tc.v1.common.lib.metadata.allLabels" $rootCtx | fromYaml)) -}}
  {{- with (include "tc.v1.common.lib.metadata.render" (dict "rootCtx" $rootCtx "labels" $labels) | trim) }}
  labels:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- $annotations := (mustMerge ($objectData.annotations | default dict) (include "tc.v1.common.lib.metadata.allAnnotations" $rootCtx | fromYaml)) -}}
  {{- with (include "tc.v1.common.lib.metadata.render" (dict "rootCtx" $rootCtx "annotations" $annotations) | trim) }}
  annotations:
    {{- . | nindent 4 }}
  {{- end }}
spec:
  {{- include "tc.v1.common.lib.workload.daemonsetSpec" (dict "rootCtx" $rootCtx "objectData" $objectData) | indent 2 }}
  selector:
    matchLabels:
      {{- include "tc.v1.common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "pod" "objectName" $objectData.shortName) | trim | nindent 6 }}
  template:
    metadata:
        {{- $labels := (mustMerge ($objectData.podSpec.labels | default dict)
                                  (include "tc.v1.common.lib.metadata.allLabels" $rootCtx | fromYaml)
                                  (include "tc.v1.common.lib.metadata.podLabels" $rootCtx | fromYaml)
                                  (include "tc.v1.common.lib.metadata.selectorLabels" (dict "rootCtx" $rootCtx "objectType" "pod" "objectName" $objectData.shortName) | fromYaml)) -}}
        {{- with (include "tc.v1.common.lib.metadata.render" (dict "rootCtx" $rootCtx "labels" $labels) | trim) }}
      labels:
        {{- . | nindent 8 }}
        {{- end -}}
        {{- $annotations := (mustMerge ($objectData.podSpec.annotations | default dict)
                                        (include "tc.v1.common.lib.metadata.allAnnotations" $rootCtx | fromYaml)
                                        (include "tc.v1.common.lib.metadata.externalInterfacePodAnnotations" (dict "rootCtx" $rootCtx "objectData" $objectData) | fromYaml)
                                        (include "tc.v1.common.lib.metadata.podAnnotations" $rootCtx | fromYaml)) -}}
        {{- with (include "tc.v1.common.lib.metadata.render" (dict "rootCtx" $rootCtx "annotations" $annotations) | trim) }}
      annotations:
        {{- . | nindent 8 }}
        {{- end }}
    spec:
      {{- include "tc.v1.common.lib.workload.pod" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim | nindent 6 }}
{{- end -}}
