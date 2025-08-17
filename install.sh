#!/bin/bash
# install.sh — установка x-ui log watcher

set -e

SCRIPT_URL="https://raw.githubusercontent.com/middtho-dev/xui-log-watcher/main/xui-log-watcher.sh"
SCRIPT_PATH="/usr/local/bin/xui-log-watcher.sh"
SERVICE_PATH="/etc/systemd/system/xui-log-watcher.service"

echo "[*] Скачиваем скрипт..."
curl -s -o "$SCRIPT_PATH" "$SCRIPT_URL"
chmod +x "$SCRIPT_PATH"

echo "[*] Создаём systemd-сервис..."
cat <<EOF > "$SERVICE_PATH"
[Unit]
Description=X-UI Log Watcher
After=network.target

[Service]
Type=simple
ExecStart=$SCRIPT_PATH
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "[*] Перезагружаем systemd и включаем сервис..."
systemctl daemon-reload
systemctl enable xui-log-watcher
systemctl start xui-log-watcher

echo "[*] Установка завершена! Сервис xui-log-watcher запущен и будет работать после перезагрузки."
