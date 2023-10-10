#!/bin/bash

# Проверка наличия прав sudo
if [ $(id -u) -ne 0 ]; then
  echo "Этот скрипт требует прав суперпользователя (sudo)."
  exit 1
fi

# Включение строгого режима (-e)
set -e

# Путь к файлу для загрузки
download_file="amdgpu-install_5.5.50503-1_all.deb"

# Проверка наличия файла перед загрузкой
if [ -e "$download_file" ]; then
  echo "Файл $download_file уже существует. Пропуск этапа загрузки."
else
  # Обновление списка пакетов и обновление системы
  apt update && apt upgrade -y

  # Загрузка AMDGPU пакета
  wget https://repo.radeon.com/amdgpu-install/23.10.3/ubuntu/focal/amdgpu-install_5.5.50503-1_all.deb
fi

# Установка AMDGPU пакета
sudo apt-get install ./$download_file

# Повторное обновление списка пакетов
sudo apt-get update

# Установка AMDGPU с параметрами
sudo amdgpu-install -y --accept-eula --usecase=opencl --opencl=rocr,legacy

# Выключение строгого режима (-e), так как далее мы сами обрабатываем ошибку
set +e

# Проверка статуса установки
if [ $? -eq 0 ]; then
  echo "Установка AMDGPU завершена успешно."
else
  echo "Возникла ошибка при установке AMDGPU."
fi

