# СРОЧНОЕ ИСПРАВЛЕНИЕ МОДАЛОК

## Проблема
Модалки не видны хотя открываются (логи норм)

## Решение
Увеличил z-index модалок до 99999 
Затемнение фона до 0.7

## Загрузите СРОЧНО
frontend/css/main.css

## После загрузки
Ctrl+Shift+F5 (полная очистка кэша)

## Если не помогло
Откройте F12 → Console, напишите:
```
document.querySelector('.modal').style.zIndex = '999999'
document.querySelector('.modal').style.display = 'flex'
```
