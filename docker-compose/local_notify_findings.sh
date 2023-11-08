#!/bin/sh

while getopts "f:t:c:" opt; do
  case $opt in
    f)
      FILE="$OPTARG"
      ;;
    t)
      SLACK_TOKEN="$OPTARG"
      ;;
    c)
      SLACK_CHANNEL="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

OUTPUT=""
if [ -f "$FILE" ]; then
    if jq -e '.scanFindings' $FILE >/dev/null; then
        for i in $(jq '.scanFindings | length' $FILE)
        do  
            item=$( jq .scanFindings[$(($i-1))] $FILE)
            title=$(echo "$item" | jq .vulnerability.title)
            severity=$(echo "$item" | jq .vulnerability.severity)
            ip=$(echo "$item" | jq .targetInfo.networkEndpoints[0].ipAddress.address)
            port=$(echo "$item" | jq .networkService.networkEndpoint.port.portNumber)
            description=$(echo "$item" | jq .vulnerability.description)
            OUTPUT="$OUTPUT
Tsunami found vulnerabilities:
- title: $title
  severity: $severity
  ip: $ip
  port: $port
  description: $description"

        done
        echo "$OUTPUT"
        curl -s -d "text=$OUTPUT" -d "channel=$SLACK_CHANNEL" \
         -H "Authorization: Bearer $SLACK_TOKEN" -X POST https://slack.com/api/chat.postMessage > /dev/null \
          && echo "Slack notification sent" || echo "Slack API call failed!" 
        echo "Slack notification sent"
    else
        echo "Scan complete, no vulnerabilities found"
    fi 
else
    echo "Scan result file not found!"
    exit 1
fi