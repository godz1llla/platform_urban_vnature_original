#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Усовершенствованный парсер HTML расписания для Urban College Platform
Извлекает данные из сложной HTML таблицы и генерирует SQL INSERT statements
"""

from bs4 import BeautifulSoup
import re
from datetime import datetime
import sys

# Маппинг дней недели (казахский → английский)
DAYS_MAPPING = {
    'ДҮЙСЕНБІ': 'monday',
    'СЕЙСЕНБІ': 'tuesday',
    'СӘРСЕНБІ': 'wednesday',
    'БЕЙСЕНБІ': 'thursday',
    'ЖҰМА': 'friday',
    'СЕНБІ': 'saturday'
}

# Маппинг времени пар
PAIR_TIMES = {
    1: ('09:00:00', '10:20:00'),
    2: ('10:30:00', '11:50:00'),
    3: ('12:20:00', '13:40:00'),
    4: ('13:50:00', '15:10:00')
}

def clean_text(text):
    """Очистка текста от лишних пробелов и переносов"""
    if not text:
        return ''
    # Убираем множественные пробелы и переносы строк
    text = ' '.join(text.split())
    # Убираем подчёркивания
    text = text.replace('_', ' ')
    return text.strip()

def extract_pair_number(text):
    """Извлечение номера пары из текста"""
    # Ищем цифру в начале текста
    match = re.match(r'^(\d+)', text)
    if match:
        return int(match.group(1))
    return None

def extract_time(text):
    """Извлечение времени из текста типа '09.00-10.20'"""
    # Паттерн для времени
    match = re.search(r'(\d{2})\.(\d{2})-(\d{2})\.(\d{2})', text)
    if match:
        start_h, start_m, end_h, end_m = match.groups()
        return f"{start_h}:{start_m}:00", f"{end_h}:{end_m}:00"
    return None, None

def extract_audience(text):
    """Извлечение номера аудитории"""
    # Паттерн для аудитории: №123, №301 и т.д.
    match = re.search(r'№(\d{3})', text)
    if match:
        return f"№{match.group(1)}"
    return None

def is_group_header(text):
    """Проверка, является ли текст заголовком группы"""
    # Паттерн для групп: ГД-124, ТЭ-223, ВД-324 и т.д.
    # Может быть как кириллица, так и латиница
    pattern = r'[А-ЯӘІҢҒҮҰҚӨҺа-яәіңғүұқөһA-Za-z]{1,3}-\d{3}'
    return bool(re.search(pattern, text))

def parse_html_schedule(html_file):
    """Парсинг HTML файла с расписанием"""
    
    print(f"📖 Читаю файл: {html_file}")
    try:
        with open(html_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"❌ Ошибка чтения файла: {e}")
        return []
    
    soup = BeautifulSoup(content, 'html.parser')
    
    # Найти все таблицы
    tables = soup.find_all('table')
    print(f"✅ Найдено таблиц: {len(tables)}")
    
    schedule_data = []
    
    # Обрабатываем каждую таблицу
    for table_idx, table in enumerate(tables):
        print(f"\n🔍 Обработка таблицы #{table_idx + 1}...")
        
        rows = table.find_all('tr')
        current_day = None
        current_group = None
        current_pair = None
        
        for row in rows:
            cells = row.find_all(['td', 'th'])
            
            # Пропускаем пустые строки
            if not cells:
                continue
            
            # Обрабатываем каждую ячейку
            row_text = []
            for cell in cells:
                text = clean_text(cell.get_text())
                if text:
                    row_text.append(text)
            
            if not row_text:
                continue
            
            # Объединяем весь текст строки
            full_row_text = ' '.join(row_text)
            
            # Определяем день недели
            for day_kz, day_en in DAYS_MAPPING.items():
                if day_kz in full_row_text.upper():
                    current_day = day_en
                    print(f"  📅 День: {day_kz} ({day_en})")
                    break
            
            # Определяем номер пары
            for text in row_text:
                pair_num = extract_pair_number(text)
                if pair_num and 1 <= pair_num <= 4:
                    current_pair = pair_num
                    break
            
            # Ищем название группы
            for text in row_text:
                if is_group_header(text):
                    # Извлекаем только код группы
                    match = re.search(r'([А-ЯӘІҢҒҮҰҚӨҺа-яәіңғүұқөһA-Za-z]{1,3}-\d{3})', text)
                    if match:
                        current_group = match.group(1)
                        print(f"  👥 Группа: {current_group}")
            
            # Если есть все необходимые данные, пытаемся извлечь урок
            if current_day and current_pair and current_group:
                # Ищем предмет, аудиторию, преподавателя
                subject = None
                audience = None
                instructor = None
                
                for i, text in enumerate(row_text):
                    # Аудитория
                    aud = extract_audience(text)
                    if aud:
                        audience = aud
                    
                    # Проп ускаем системные слова
                    if text in ['Пара', 'пара'] or extract_pair_number(text) or text in DAYS_MAPPING.keys():
                        continue
                    
                    # Если текст содержит точки (ФИО преподавателя)
                    if '.' in text and len(text) > 5:
                        # Это скорее всего имя преподавателя
                        instructor = text
                    # Если это не аудитория и не слишком короткий текст
                    elif not aud and len(text) > 3 and not extract_pair_number(text):
                        # Это может быть название предмета
                        if not subject:
                            subject = text
                
                # Если нашли урок, добавляем в данные
                if subject and current_pair:
                    time_start, time_end = PAIR_TIMES[current_pair]
                    
                    entry = {
                        'group_name': current_group,
                        'day_of_week': current_day,
                        'pair_number': current_pair,
                        'time_start': time_start,
                        'time_end': time_end,
                        'subject': subject,
                        'audience': audience or 'Не указано',
                        'instructor': instructor or 'Не указан'
                    }
                    
                    schedule_data.append(entry)
                    print(f"    ✓ Пара {current_pair}: {subject} ({audience}) - {instructor}")
    
    return schedule_data

def generate_sql_insert(schedule_data):
    """Генерация SQL INSERT statements"""
    
    sql_lines = []
    sql_lines.append("-- ============================================================================")
    sql_lines.append("-- ПОЛНЫЙ ИМПОРТ РАСПИСАНИЯ")
    sql_lines.append(f"-- Сгенерировано: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    sql_lines.append(f"-- Записей: {len(schedule_data)}")
    sql_lines.append("-- ============================================================================")
    sql_lines.append("")
    sql_lines.append("-- Очистка существующих данных расписания")
    sql_lines.append("TRUNCATE TABLE schedule;")
    sql_lines.append("")
    
    # Группируем по уникальным комбинациям чтобы избежать дубликатов
    unique_entries = {}
    duplicates_removed = 0
    
    for entry in schedule_data:
        # Создаем уникальный ключ
        key = (
            entry['group_name'],
            entry['day_of_week'],
            entry['pair_number'],
            entry['subject'],
            entry['audience']
        )
        
        if key not in unique_entries:
            unique_entries[key] = entry
        else:
            duplicates_removed += 1
    
    print(f"\n📊 Статистика:")
    print(f"  Всего записей: {len(schedule_data)}")
    print(f"  Уникальных: {len(unique_entries)}")
    print(f"  Дубликатов удалено: {duplicates_removed}")
    
    # Генерируем SQL для уникальных записей
    for entry in unique_entries.values():
        # Экранируем кавычки в данных
        subject = entry['subject'].replace("'", "\\'")
        instructor = entry['instructor'].replace("'", "\\'")
        
        sql = f"""INSERT INTO schedule (group_id, subject_id, instructor_id, audience, day_of_week, pair_number, time_start, time_end)
VALUES (
    (SELECT id FROM `groups` WHERE name = '{entry['group_name']}' LIMIT 1),
    (SELECT id FROM subjects WHERE name LIKE '%{subject}%' LIMIT 1),
    (SELECT id FROM users WHERE full_name LIKE '%{instructor.split()[0]}%' AND role = 'instructor' LIMIT 1),
    '{entry['audience']}',
    '{entry['day_of_week']}',
    {entry['pair_number']},
    '{entry['time_start']}',
    '{entry['time_end']}'
);"""
        sql_lines.append(sql)
        sql_lines.append("")
    
    return '\n'.join(sql_lines)

def main():
    """Главная функция"""
    
    input_file = '../Расписание 1-4 курс 2026 гг от 20.01.2026.html'
    output_file = 'import_schedule_full.sql'
    
    print("🚀 Начинаю парсинг расписания...")
    print(f"📁 Входной файл: {input_file}")
    print(f"💾 Выходной файл: {output_file}")
    print("")
    
    schedule_data = parse_html_schedule(input_file)
    
    if schedule_data:
        print(f"\n💾 Генерирую SQL файл...")
        sql_content = generate_sql_insert(schedule_data)
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(sql_content)
        
        print(f"✅ SQL файл создан: {output_file}")
        print(f"📝 Готово! Можно импортировать в базу данных.")
    else:
        print("⚠️ Данные не найдены. Проверьте структуру HTML файла.")
        return 1
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
