#!/bin/sh

BOT_TOKEN="6602514727:AAF7d2iEQmH5YbynKSZH-lPA9-BDUNmjphY"
CHAT_ID="382094545"

escape_markdown() {
    echo "$1" \
        | sed 's/\./\\./g' \
        | sed 's/-/\\-/g' \
        | sed 's/(/\\(/g' \
        | sed 's/)/\\)/g' \
        | sed 's/_/\\_/g' \
        | sed 's/!/\\!/g'
}

journalctl -u x-ui -n0 -f | while read -r line; do
    [ -z "$line" ] && continue

    DATE=$(echo "$line" | awk '{print $1" "$2" "$3}')
    HOST=$(echo "$line" | awk '{print $4}')
    LEVEL=$(echo "$line" | grep -o "INFO\|WARNING\|ERROR" | head -n1)
    EVENT=$(echo "$line" | cut -d':' -f4- | sed 's/^ //')

    case "$LEVEL" in
        INFO)    ICON="🟢";;
        WARNING) ICON="🟡";;
        ERROR)   ICON="🔴";;
        *)       ICON="⚪️"; LEVEL="OTHER";;
    esac

    IP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
    [ -z "$IP" ] && IP="-"

    DATE_ESC=$(escape_markdown "$DATE")
    HOST_ESC=$(escape_markdown "$HOST")
    LEVEL_ESC=$(escape_markdown "$LEVEL")
    EVENT_ESC=$(escape_markdown "$EVENT")
    IP_ESC=$(escape_markdown "$IP")

    # <<EOF делает настоящие переводы строк
    MSG=$(cat <<EOF
${ICON} *${LEVEL_ESC}*
📄 *Время:* \`${DATE_ESC}\`
🖥️ *Хост:* \`${HOST_ESC}\`
👤 *Событие:* \`${EVENT_ESC}\`
🌍 *IP:* \`${IP_ESC}\`
EOF
)

    curl -s "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d "chat_id=$CHAT_ID" \
        -d "parse_mode=MarkdownV2" \
        --data-urlencode "text=$MSG" >/dev/null
done
