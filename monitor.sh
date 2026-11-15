#!/bin/bash

# Файлы для логов и хранения PID
LOG_FILE="/var/log/monitoring.log"
PID_FILE="/tmp/test_process.pid"
API_URL="https://test.com/monitoring/test/api"

# 1. Ищем процесс test
PID=$(pgrep -x "test")

if [ -n "$PID" ]; then
    # Процесс запущен. Проверяем, был ли перезапуск
    if [ -f "$PID_FILE" ]; then
        OLD_PID=$(cat "$PID_FILE")
        if [ "$OLD_PID" != "$PID" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Процесс test был перезапущен. Новый PID: $PID" >> "$LOG_FILE"
        fi
    fi
    # Сохраняем текущий PID
    echo "$PID" > "$PID_FILE"

    # 2. Стучимся на сервер мониторинга
     # Сохраняем HTTP-код ответа (добавлено по замечанию ML-инженера)
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -f -m 10 --max-filesize 1000000 "$API_URL")
    
    # Если curl вернул ошибку (код возврата не 0)
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Сервер мониторинга недоступен" >> "$LOG_FILE"
    fi
else
    # Процесс не запущен - ничего не делаем (по заданию)
    exit 0
fi
