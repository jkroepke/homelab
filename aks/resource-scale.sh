#!/usr/bin/env bash

for i in $(seq 0 50 800); do
  echo $i

  for j in $(seq "$i" $((i + 49)) ); do
    az keyvault create --no-wait --only-show-errors --location westus3 --name "kv-scale-$j" --resource-group rg-resource-scale --subscription 1988b893-553c-4652-bd9b-52f089b21ead &
  done

  # shellcheck disable=SC2046
  wait $(jobs -p)

  sleep 10
done

for i in $(seq 800 50 1600); do
  echo $i

  for j in $(seq "$i" $((i + 49)) ); do
    az keyvault create --no-wait --only-show-errors --location westus3 --name "kv-scale-$j" --resource-group rg-resource-scale-2 --subscription 1988b893-553c-4652-bd9b-52f089b21ead &
  done

  # shellcheck disable=SC2046
  wait $(jobs -p)

  sleep 10
done
