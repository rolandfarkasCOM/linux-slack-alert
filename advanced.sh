#!/bin/bash
if [ "$PAM_TYPE" != "close_session" ]; then
    url="<YOUR SLACK WEBHOOK>"
    channel="#channel"
    host="$(hostname)"
    special_name="YourSpecialName"  # Define your special name
    group="OptionalGroupName"       # Define your optional group (can be left empty)
    ip_api_url="https://freeipapi.com/api/json/$PAM_RHOST"

    # Define which fields you want to include (e.g., country, city, isProxy, etc.)
    ip_fields=("countryName" "cityName" "latitude" "longitude")

    # Fetch IP information if IP exists
    if [ -n "$PAM_RHOST" ]; then
        ip_info=$(curl -s "$ip_api_url")

        # Initialize optional fields
        ip_details=""
        
        # Loop over the fields and extract values from the API response
        for field in "${ip_fields[@]}"; do
            value=$(echo "$ip_info" | jq -r ".${field}")
            if [ "$value" != "null" ]; then
                ip_details+="$field: $value, "
            fi
        done
        
        # Remove trailing comma and space
        ip_details=$(echo "$ip_details" | sed 's/, $//')
    fi

    # Adjust content based on whether group is defined
    if [ -z "$group" ]; then
        content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \"SSH login: $PAM_USER connected to \`$host\` - $special_name\", \"text\": \"SSH login to \`$host\` - $special_name\", \"fields\": [ { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, { \"title\": \"IP Address\", \"value\": \"$PAM_RHOST\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
    else
        content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \"SSH login: $PAM_USER connected to \`$host\` - $special_name ($group)\", \"text\": \"SSH login to \`$host\` - $special_name ($group)\", \"fields\": [ { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, { \"title\": \"IP Address\", \"value\": \"$PAM_RHOST\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
    fi

    # Append IP details to the content if fetched
    if [ -n "$ip_details" ]; then
        content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \"SSH login: $PAM_USER connected to \`$host\` - $special_name\", \"text\": \"SSH login to \`$host\` - $special_name ($group) \n *IP Details:* $ip_details\", \"fields\": [ { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, { \"title\": \"IP Address\", \"value\": \"$PAM_RHOST\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
    fi
    
    curl -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"mrkdwn\": true, \"username\": \"SSH Alert\", $content, \"icon_emoji\": \":closed_lock_with_key:\"}" "$url" &
fi
exit