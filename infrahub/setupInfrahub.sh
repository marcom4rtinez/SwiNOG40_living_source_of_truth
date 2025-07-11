#!/bin/bash

cd infrahub

poetry config virtualenvs.create true
poetry install --no-interaction --no-ansi

poetry run invoke start

sleep 30

# Load infra-schema + infra-topology
poetry run invoke load-schema

# Wait a bit extra to be sure the schema are properly loaded
sleep 30

# Load infra-data
poetry run invoke load-data

cd ..

helm install vidra-operator oci://ghcr.io/infrahub-operator/vidra/helm-charts/vidra-operator --namespace vidra-system --create-namespace

kubectl apply -f vidra.yml