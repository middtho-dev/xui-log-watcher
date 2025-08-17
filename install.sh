#!/bin/bash
set -e

GITHUB_RAW="https://raw.githubusercontent.com/middtho-dev/xui-log-watcher/main"

echo "[*] Скачиваем xui-log-watcher.sh..."
curl -s -o /usr/local/bin/xui-log-watcher.sh "$GITHUB_RAW/xui-log-watcher.sh"
chmod +x /usr/local/bin/xui-log-watcher.sh

echo "[*] Создаем systemd-сервис..."
cat <<EOF > /etc/systemd/system/xui-log-watcher.service
[Unit]
Description=X-UI Log Watcher
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/xui-log-watcher.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "[*] Перезагружаем systemd и включаем сервис..."
systemctl daemon-reload
systemctl enable xui-log-watcher.service
systemctl start xui-log-watcher.service

echo "[*] Установка завершена. Сервис запущен и будет работать при старте системы."
