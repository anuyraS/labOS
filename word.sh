#!/bin/bash

# Проверка
if [ "$#" -ne 4 ]; then
    echo "Использование: $0 <директория> <старое_слово> <новое_слово> <файл_списка>"
    exit 1
fi

DIRECTORY=$1
OLD_WORD=$2
NEW_WORD=$3
OUTPUT_FILE=$4

# Создаем или очищаем файл списка
> "$OUTPUT_FILE"

# Проходим по всем текстовым файлам в указанной директории
find "$DIRECTORY" -type f -name "*.txt" | while read -r FILE; do
    # Проверяем, содержит ли файл старое слово
    if grep -q "$OLD_WORD" "$FILE"; then
        # Заменяем старое слово на новое
        sed -i "s/\b$OLD_WORD\b/$NEW_WORD/g" "$FILE"
        
        # Добавляем файл в список измененных файлов
        echo "$FILE" >> "$OUTPUT_FILE"
    fi
done

echo "Замена завершена, список измененных файлов сохранен в $OUTPUT_FILE."
