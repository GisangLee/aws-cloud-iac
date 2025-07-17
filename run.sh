#!/bin/bash

ENV=$1

cd environment/$ENV || exit 1
 terraform init
 terraform plan -var-file="terraform.tfvars"