#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Скрипт для исправления дубликатов student_code в import_students.sql
"""

import re
from collections import defaultdict

# Читаем файл
with open('import_students.sql', 'r', encoding='utf-8') as f:
    content = f.read()

# Находим все student_code
pattern = r"\('STU\d+'"
matches = re.findall(pattern, content)

# Подсчитываем дубликаты
code_counts = defaultdict(int)
for match in matches:
    code = match[2:-1]  # Убираем (' и '
    code_counts[code] += 1

print(f"Всего student_code: {len(matches)}")
print(f"Уникальных: {len(code_counts)}")
print(f"Дубликатов: {sum(1 for count in code_counts.values() if count > 1)}")

# Исправляем дубликаты
seen_codes = {}
fixed_count = 0

def replace_code(match):
    global fixed_count
    full_match = match.group(0)
    # Извлекаем код студента
    code_match = re.search(r"'(STU\d+)'", full_match)
    if not code_match:
        return full_match
    
    code = code_match.group(1)
    
    if code not in seen_codes:
        seen_codes[code] = 0
        return full_match
    else:
        # Это дубликат! Нужно изменить
        seen_codes[code] += 1
        # Генерируем новый уникальный код
        base_number = int(code[3:])  # Убираем 'STU'
        new_code = f"STU{base_number}{seen_codes[code]:02d}"
        
        # Проверяем, что новый код уникален
        while new_code in seen_codes:
            seen_codes[code] += 1
            new_code = f"STU{base_number}{seen_codes[code]:02d}"
        
        seen_codes[new_code] = 0
        fixed_count += 1
        
        # Заменяем код в строке
        new_match = full_match.replace(f"'{code}'", f"'{new_code}'", 1)
        print(f"✓ Исправлен дубликат: {code} → {new_code}")
        return new_match

# Находим и заменяем все INSERT записи студентов
# Шаблон: (id, user_id, 'STU...', ...)
pattern_full = r"\(\d+,\s*\d+,\s*'STU\d+',\s*\([^)]+\)[^)]*\)"

content_fixed = re.sub(pattern_full, replace_code, content)

# Сохраняем исправленный файл
with open('import_students_fixed.sql', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print(f"\n✅ Исправлено {fixed_count} дубликатов")
print(f"✅ Результат сохранен в: import_students_fixed.sql")
