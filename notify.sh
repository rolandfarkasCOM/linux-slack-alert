#!/bin/bash
if [ "$PAM_TYPE" != "close_session" ]; then
    url="<YOUR SLACK WEBHOOK>"
    channel="#channel"
    host="$(hostname)"
    special_name="YourSpecialName"  # Define your special name
    group="OptionalGroupName"       # Define your optional group (can be left empty)

    # Adjust content based on whether group is defined
    if [ -z "$group" ]; then
        content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \"SSH login: $PAM_USER connected to \`$host\` - $special_name\", \"text\": \"SSH login to \`$host\` - $special_name\", \"fields\": [ { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, { \"title\": \"IP Address\", \"value\": \"$PAM_RHOST\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
    else
        content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \"SSH login: $PAM_USER connected to \`$host\` - $special_name ($group)\", \"text\": \"SSH login to \`$host\` - $special_name ($group)\", \"fields\": [ { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, { \"title\": \"IP Address\", \"value\": \"$PAM_RHOST\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
    fi

    curl -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"mrkdwn\": true, \"username\": \"SSH Alert\", $content, \"icon_emoji\": \":closed_lock_with_key:\"}" "$url" &
fi
exit