-- =================================================================
-- IMPORT: Employees (Сотрудники)
-- Source: күнгі қызметкерлер құрамының экспорты.csv
-- Date: 2026-01-09
-- Records: 30 сотрудников
-- =================================================================

SET NAMES utf8mb4;

-- Пароль для всех: password123
-- Hash: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi

INSERT INTO `users` (`full_name`, `email`, `password_hash`, `role`, `position`) VALUES
-- Администрация
('Алмаходжаева Юлдузхон Бахтыбаевна', 'almakhodjaeva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Директор'),
('Олжабаева Баян Оразбековна', 'olzhabaeva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Директордың оқу-әдістемелік жұмысы жөніндегі орынбасары'),
('Енкенов Бауржан Болатханович', 'enkenov@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Директордың ғылыми-әдістемелік жұмыс жөніндегі орынбасары'),
('Жарманов Ербол Рамазанович', 'zharmanov@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Меңгерушінің шаруашылық бөлім жөніндегі орынбасары'),

-- Преподаватели (общеобразовательные предметы)
('Уатхан Кульжан', 'uatkhan@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы білім беру пәндері бойынша оқытушы'),
('Мусалаева Оксана Григорьевна', 'musalayeva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы білім беру пәндері бойынша оқытушы'),
('Хамитова Мархамат Мансуровна', 'khamitova@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы білім беру пәндері бойынша оқытушы'),
('Төребаева Аружан Қадырқызы', 'torebayeva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы білім беру пәндері бойынша оқытушы'),
('Раймбаева Жанерке Еркасымовна', 'raimbayeva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы білім беру пәндері бойынша оқытушы'),
('Байдильдина Камилла Ермековна', 'baidildina@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы білім беру пәндері бойынша оқытушы'),
('Садувакас Шынар Бауыржанқызы', 'saduvakas@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы білім беру пәндері бойынша оқытушы'),

-- Преподаватели (профессиональные предметы)
('Баден Ақмаржан', 'baden@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы кәсіптік және арнайы пәндер бойынша оқытушы'),
('Кокенов Ахмаджан Абдирасулович', 'kokenov@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы кәсіптік және арнайы пәндер бойынша оқытушы'),
('Есимханов Куаныш Бекежанович', 'yessimkhanov@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы кәсіптік және арнайы пәндер бойынша оқытушы'),
('Валиев Сагинбай Тлекович', 'valiyev@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы кәсіптік және арнайы пәндер бойынша оқытушы'),
('Абильмажинов Руслан Бекзатович', 'abilmazhinov@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Жалпы кәсіптік және арнайы пәндер бойынша оқытушы'),

-- Преподаватели (общие)
('Амангельдиев Алихан Нуркасымович', 'amangeldi@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Оқытушы'),
('Махин Азамат Сабиржанович', 'makhin@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Оқытушы'),
('Орынбасар Жұлдыз Арманқызы', 'orynbasar@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Оқытушы'),
('Нұржанұлы Нұрбол', 'nurbol@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Оқытушы'),
('Жумаканов Айдос Ертаргынович', 'zhumakanov@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Оқытушы'),

-- Кураторы
('Құрымова Мейрамгүл Кенжетайқызы', 'kurymova@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Педагог-ұйымдастырушы куратор'),
('Ельчубаева Линура Маратовна', 'yelchubayeva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'instructor', 'Педагог-ұйымдастырушы куратор'),

-- Прочий персонал
('Сейткасимова Айнур Габдыгапаровна', 'seitkassimova@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Басшы'),
('Қарсақбаева Таңшолпан Серікқалиқызы', 'karsakbayeva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Офис-тіркеуші'),
('Касымова Асемгүл Серікқызы', 'kassymova@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Әлеуметтік педагог'),
('Тұрарұлы Жандос', 'zhandos@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Жүйелік әкімші'),
('Кобалова Жадыра Еркиновна', 'kobalova@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Архивариус'),
('Журавлева Ольга Викторовна', 'zhuravleva@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Психолог');

-- Оператор столовой (добавляем роль)
INSERT INTO `users` (`full_name`, `email`, `password_hash`, `role`, `position`) VALUES
('Оператор Столовой', 'cafeteria@urbancollege.kz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'cafeteria_operator', 'Оператор столовой');
