#!/bin/bash

ENV=$1


# 이동 전에 저장
ENV_DIR="environment/$ENV"
MODULE_DIR="../../modules"


# ✅ 환경 디렉터리 진입
cd "$ENV_DIR" || exit 1

echo "📦 terraform init..."
terraform init

echo "🧹 formatting .tf files in environment..."
terraform fmt -recursive -write=true -list=true

echo "🧹 formatting .tf files in modules..."
terraform fmt -recursive -write=true -list=true "$MODULE_DIR"

echo "🔍 running terraform plan..."
terraform plan -var-file="terraform.tfvars"