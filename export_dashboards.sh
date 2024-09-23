# podman run --network grafana-graphite-statsd_default \
#     -v ./grafana/dashboards:/dashboards \
#     grafana-dashboard-manager \
#     download \
#     --scheme http \
#     --port 3000 \
#     --host grafana \
#     --non-interactive \
#     --username admin --password admin \
#     --destination /dashboards



export HOST=http://localhost:3000

for dash in $(curl -s -k -H "Authorization: Bearer ${KEY}" ${HOST}/api/search\?query\=\& | jq -r '.[] | select(.type == "dash-db") | .uid'); do
  curl -s -k -H "Authorization: Bearer ${KEY}" ${HOST}/api/dashboards/uid/$dash \
    | jq '. |= (.folderUid=.meta.folderUid) | del(.meta) |del(.dashboard.id) + {overwrite: true}' \
    > "./grafana/dashboards/${dash}.json"
  echo "Dashboard: ${NAME} - ${dash} saved."
done
