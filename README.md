# Мониторинг процесса test (DevOps, Effective Mobile)

Тестовое задание для стажёра DevOps. Скрипт на Bash + systemd.

**Исходное задание:** [https://github.com/9868-08/Effective-Mobile/tree/master](https://github.com/9868-08/Effective-Mobile/tree/master)

## Что это?

Bash-скрипт `monitor.sh`, который проверяет наличие процесса `test` в системе. Если процесс запущен, скрипт отправляет HTTPS-запрос на `https://test.com/monitoring/test/api` и логирует ошибки в `/var/log/monitoring.log`. Также созданы юнит `monitor.service` и таймер `monitor.timer` для запуска каждую минуту.

## **Как запустить**

Все команды нужно выполнять из папки, куда вы склонировали этот репозиторий.

1. Установите `curl` (если ещё не установлен):
   ```bash
   sudo apt update
   sudo apt install curl -y

2. Скопируйте файлы в системные директории:
   ```bash
   sudo cp monitor.sh /usr/local/bin/monitor.sh
   sudo cp monitor.service /etc/systemd/system/monitor.service
   sudo cp monitor.timer /etc/systemd/system/monitor.timer

3. Дайте права на выполнение скрипту:
   ```bash
   sudo chmod +x /usr/local/bin/monitor.sh
4. Перезагрузите конфигурацию systemd и запустите таймер:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start monitor.timer
   sudo systemctl enable monitor.timer
5. Проверьте статус таймера (должно быть active (waiting)):
   ```bash
   sudo systemctl status monitor.timer

## **Как проверить работу**
1. Создайте фейковый процесс test (он будет висеть 5 минут):
   ```bash
   perl -e '$0="test"; sleep 300'

2. Запустите сервис вручную (чтобы не ждать минуту):
   ```bash
   sudo systemctl start monitor.service

3. Посмотрите лог:
   ```bash
   cat /var/log/monitoring.log
Ожидаемый результат: в логе появится запись «Сервер мониторинга недоступен (HTTP-код: 000)»

## **Что сделано**
1) Написан Bash-скрипт для мониторинга процесса test.
2) Создан юнит systemd (monitor.service) и таймер (monitor.timer).
3) Реализовано логирование в /var/log/monitoring.log.
4) Добавлена проверка HTTP-кода ответа (по замечанию ML-инженера).
5) Добавлено ограничение размера ответа --max-filesize (по замечанию ML-инженера).

## **Что не сделано (и почему)**
1) Не реализована обработка перезапуска процесса (пункт 4 задания) — не хватило времени, основной сценарий от этого не зависит.
2) Не реализован вывод тела ответа API в лог — планируется в будущем.
