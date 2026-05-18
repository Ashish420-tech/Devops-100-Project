#!/bin/bash



cat <<EOF > Chart.yaml
apiVersion: v2
name: myapp
description: Production Helm chart for nginx application
type: application

version: 1.0.0
appVersion: "1.0"
EOF

cat <<EOF > values.yaml
replicaCount: 1

image:
  repository: nginx
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

env: dev

ingress:
  enabled: false

autoscaling:
  enabled: false

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
EOF

cat <<EOF > values-dev.yaml
replicaCount: 1
env: dev
EOF

cat <<EOF > values-staging.yaml
replicaCount: 2
env: staging
EOF

cat <<EOF > values-prod.yaml
replicaCount: 3
env: production
EOF

cat <<EOF > templates/_helpers.tpl
{{- define "myapp.name" -}}
myapp
{{- end }}

{{- define "myapp.fullname" -}}
{{ .Release.Name }}
{{- end }}
EOF

cat <<EOF > templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "myapp.fullname" . }}
data:
  APP_ENV: {{ .Values.env | quote }}
EOF

cat <<EOF > templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "myapp.fullname" . }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "myapp.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "myapp.name" . }}
    spec:
      containers:
        - name: nginx
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: {{ include "myapp.fullname" . }}
          resources:
{{ toYaml .Values.resources | indent 12 }}
EOF

cat <<EOF > templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "myapp.fullname" . }}
spec:
  type: {{ .Values.service.type }}
  selector:
    app: {{ include "myapp.name" . }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: 80
EOF

cat <<EOF > templates/NOTES.txt
Application deployed successfully!

Check pods:
kubectl get pods

Check service:
kubectl get svc

Environment:
{{ .Values.env }}
EOF
