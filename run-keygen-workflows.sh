#!/bin/bash

jq -c '.[]' conf.json | while read project; do
  project_id=$(echo "$project" | jq -r '.ProjectId')
  sec_id=$(echo "$project" | jq -r '.ProjectSecId')
  webhook=$(echo "$project" | jq -r '.sapcewebhook')

  echo "Service Accounts:"
  echo "$project" | jq -r '.serviceAccountName[]' | while read sa; do
    echo "  - $sa"
    gcloud workflows run workflow-1 \
      --project lec-gal-it-sandbox-fkallel-sbx \
	  --location europe-west1 \
      --data="{
        \"ProjectId\": \"$project_id\",
        \"ProjectSecId\": \"$sec_id\",
        \"serviceAccountName\": \"$sa\",
        \"event_datetime\": \"$(date +"%Y%m%d%H%M")\",
        \"sapcewebhook\": \"$webhook\"
      }"
  done

done
