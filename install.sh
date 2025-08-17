#!/bin/bash
set -e

# Установка скрипта
echo "[*] Устанавливаю скрипт..."
cp xui-log-watcher.sh /usr/local/bin/xui-log-watcher.sh
chmod +x /usr/local/bin/xui-log-watcher.sh

# Установка systemd сервиса
echo "[*] Устанавливаю systemd service..."
cp xui-log-watcher.service /etc/systemd/system/xui-log-watcher.service

# Перезагрузка systemd и запуск
systemctl daemon-reload
systemctl enable xui-log-watcher
systemctl restart xui-log-watcher

echo "[✔] Установка завершена. Проверка статуса:"
systemctl status xui-log-watcher --no-pager
