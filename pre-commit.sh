#!/bin/bash
command -v gitleaks >/dev/null 2>&1 || { 
    echo >&2 "Gitleaks не знайдено. Встановлюю gitleaks...";
    
    # Встановлення gitleaks залежно від операційної системи
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -sSfL https://github.com/zricethezav/gitleaks/releases/latest/download/gitleaks-linux-amd64.tar.gz | tar -xz
        export PATH=$(pwd):$PATH  # Додавання поточного каталогу до шляху пошуку
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.16.4/gitleaks_8.16.4_darwin_arm64.tar.gz | tar -xz
        export PATH=$(pwd):$PATH  # Додавання поточного каталогу до шляху пошуку
    else
        echo >&2 "Не вдалося встановити gitleaks. Операційна система не підтримується."; 
        exit 1;
    fi
}

# Перевірка значення опції enable у git config
ENABLE=$(git config --bool hooks.gitleaks-enable)

# Перевірка, чи ввімкнена опція enable
if [ "$ENABLE" != "true" ]; then
    echo "Попередження: Перевірка наявності секретів у коді вимкнена. Для включення виконайте команду: git config hooks.gitleaks-enable true"
    exit 0
fi

# Запуск gitleaks для перевірки наявності секретів
gitleaks detect

# Перевірка коду вихідного повідомлення gitleaks
if [ $? -eq 0 ]; then
    echo "Помилка: Знайдено секрети у коді. Відхиляю коміт."
    exit 1
fi

# Коміт проходить перевірку, якщо немає знайдених секретів
exit 0

