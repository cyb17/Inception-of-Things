#!/bin/bash

kubectl create secret generic my-gitlab-secrets -n gitlab \
--from-literal=root-password='rootPass1' \
--from-literal=psql-password='psqlPass1' \
--from-literal=redis-password='redisPass1' \
