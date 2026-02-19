#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CSV to SQL Converter for Student Data Import
Author: AI Assistant
Date: 2026-01-09
"""

import csv
import hashlib
import re

def clean_text(text):
    """Clean and escape SQL text"""
    if not text or text == 'Көрсетілмеген' or text == 'Таңдалмаған':
        return None
    return text.replace("'", "''").strip()

def extract_specialty_code(specialty_text):
    """Extract specialty code from full text"""
    if not specialty_text:
        return None
    match = re.match(r'([0-9A-Z]+)\s*-', specialty_text)
    return match.group(1) if match else None

def parse_gender(gender_kz):
    """Convert Kazakh gender to enum"""
    if gender_kz == 'Ер':
        return 'male'
    elif gender_kz == 'Әйел':
        return 'female'
    return None

def parse_funding(funding_kz):
    """Convert Kazakh funding type to enum"""
    if funding_kz == 'бюджет':
        return 'budget'
    elif funding_kz == 'ақылы':
        return 'paid'
    return None

def parse_language(lang_kz):
    """Convert Kazakh language to enum"""
    if lang_kz == 'қазақ':
        return 'kazakh'
    elif lang_kz == 'орыс':
        return 'russian'
    return None

def generate_email(full_name, iin):
    """Generate email from full name and IIN"""
    # Take first part of name
    parts = full_name.split()
    if len(parts) >= 2:
        base = parts[1].lower()  # Usually surname is second in Kazakh names
    else:
        base = parts[0].lower()
    
    # Transliterate common Kazakh/Russian letters
    translit = {
        'ә': 'a', 'ғ': 'g', 'қ': 'k', 'ң': 'n', 'ө': 'o', 'ұ': 'u', 'ү': 'u', 'һ': 'h', 'і': 'i',
        'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo', 'ж': 'zh', 'з': 'z',
        'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r',
        'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'ts', 'ч': 'ch', 'ш': 'sh', 'щ': 'shch',
        'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya'
    }
    
    result = []
    for char in base:
        result.append(translit.get(char.lower(), char))
    
    email_base = ''.join(result)
    # Remove non-alphanumeric
    email_base = re.sub(r'[^a-z0-9]', '', email_base)
    
    # Add last 4 digits of IIN
    if iin and len(iin) >= 4:
        email_base += iin[-4:]
    
    return f"{email_base}@student.urbancollege.kz"

def parse_date(date_str):
    """Parse date in DD.MM.YYYY format"""
    if not date_str or date_str == 'Көрсетілмеген':
        return None
    try:
        parts = date_str.split('.')
        if len(parts) == 3:
            return f"{parts[2]}-{parts[1]}-{parts[0]}"  # YYYY-MM-DD
    except:
        pass
    return None

# Password hash for 'password123'
PASSWORD_HASH = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'

print("-- " + "="*70)
print("-- IMPORT: Students (681 студентов)")
print("-- Source: Контингент бойынша экспорт CSV")
print("-- Date: 2026-01-09")
print("-- " + "="*70)
print()
print("SET NAMES utf8mb4;")
print()

# Open CSV file
csv_path = '../Контингент бойынша экспорт 2026-01-09_6960df77230921.93384525.csv'

with open(csv_path, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    
    user_id = 100  # Start from 100 to avoid conflicts
    student_id = 1
    
    users_sql = []
    students_sql = []
    
    for row in reader:
        full_name = clean_text(row['Аты-жөні'])
        if not full_name:
            continue
            
        iin = clean_text(row['ЖСН'])
        email = generate_email(full_name, iin)
        
        # User record
        users_sql.append(f"({user_id}, '{full_name}', '{email}', '{PASSWORD_HASH}', 'student')")
        
        # Student record
        student_code = f"STU{iin[:6]}" if iin else f"STU{user_id:06d}"
        qr_token = f"QR_{iin}" if iin else f"QR_{user_id}"
        
        group_name = clean_text(row['Топ'])
        specialty_code = extract_specialty_code(clean_text(row['Біліктілігі']))
        
        gender = parse_gender(clean_text(row['Жынысы']))
        dob = parse_date(clean_text(row['Туған күні']))
        nationality = clean_text(row['Ұлты'])
        citizenship = clean_text(row['Азаматтық'])
        
        phone = clean_text(row['Байланыс телефоны'])
        address = clean_text(row['Мекенжай'])
        region = clean_text(row['Тұратын облысы'])
        district = clean_text(row['Ауданы'])
        city = clean_text(row['Қала/елді мекен'])
        
        edu_level = clean_text(row['Білім деңгейі'])
        funding = parse_funding(clean_text(row['Қаражат есебінен']))
        language = parse_language(clean_text(row['Оқыту тілі']))
        form = clean_text(row['Оқыту формасы'])
        
        enrollment_date = parse_date(clean_text(row['Келу/қабылдану күн']))
        enrollment_order = clean_text(row['Келу бұйрығының нөмірі'])
        academic_leave = 1 if 'Академиялық демалыс' in str(row.get('Қосымша оқу туралы', '')) else 0
        
        # Build student SQL
        student_values = [
            str(student_id),
            str(user_id),
            f"'{student_code}'",
            f"(SELECT id FROM `groups` WHERE name = '{group_name}')" if group_name else 'NULL',
            f"(SELECT id FROM `specialties` WHERE code = '{specialty_code}')" if specialty_code else 'NULL',
            f"'{qr_token}'",
            f"'{iin}'" if iin else 'NULL',
            f"'{gender}'" if gender else 'NULL',
            f"'{dob}'" if dob else 'NULL',
            f"'{nationality}'" if nationality else 'NULL',
            f"'{citizenship}'" if citizenship else 'NULL',
            f"'{phone}'" if phone else 'NULL',
            f"'{address}'" if address else 'NULL',
            f"'{region}'" if region else 'NULL',
            f"'{district}'" if district else 'NULL',
            f"'{city}'" if city else 'NULL',
            f"'{edu_level}'" if edu_level else 'NULL',
            f"'{funding}'" if funding else 'NULL',
            f"'{language}'" if language else 'NULL',
            f"'{form}'" if form else 'NULL',
            f"'{enrollment_date}'" if enrollment_date else 'NULL',
            f"'{enrollment_order}'" if enrollment_order else 'NULL',
            str(academic_leave),
            '0'  # dual_education
        ]
        
        students_sql.append(f"({', '.join(student_values)})")
        
        user_id += 1
        student_id += 1

# Print users INSERT
print("-- Insert users (students)")
print("INSERT INTO `users` (`id`, `full_name`, `email`, `password_hash`, `role`) VALUES")
print(",\n".join(users_sql) + ";")
print()

# Print students INSERT
print("-- Insert student records")
print("""INSERT INTO `students` (
  `id`, `user_id`, `student_code`, `group_id`, `specialty_id`, `qr_token`,
  `iin`, `gender`, `date_of_birth`, `nationality`, `citizenship`,
  `phone`, `address`, `region`, `district`, `city`,
  `education_level`, `funding_type`, `education_language`, `education_form`,
  `enrollment_date`, `enrollment_order`, `academic_leave`, `dual_education`
) VALUES""")
print(",\n".join(students_sql) + ";")

print()
print("-- Import complete!")
