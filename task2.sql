INSERT INTO area (area_name)
VALUES ('Москва'),
       ('Санкт-Петербург'),
       ('Уфа'),
       ('Казань'),
       ('Тверь'),
       ('Ростов-на-Дону'),
       ('Екатеринбург'),
       ('Омск'),
       ('Воронеж'),
       ('Краснодар'),
       ('Новосибирск'),
       ('Челябинск'),
       ('Волгоград'),
       ('Саратов'),
       ('Иркутск'),
       ('Махачкала');

INSERT INTO specialization (specialization_name)
VALUES ('Автомобильный бизнес'),
       ('Гостиницы, рестораны, общепит, кейтеринг'),
       ('Государственные организации'),
       ('Добывающая отрасль'),
       ('ЖКХ'),
       ('Информационные технологии, системная интеграция, интернет'),
       ('Искусство, культура'),
       ('Лесная промышленность, деревообработка'),
       ('Медицина, фармацевтика, аптеки'),
       ('Металлургия, металлообработка'),
       ('Нефть и газ'),
       ('Образовательные учреждения'),
       ('Общественная деятельность, партии, благотворительность, НКО'),
       ('Перевозки, логистика, склад, ВЭД'),
       ('Продукты питания'),
       ('Промышленное оборудование, техника, станки и комплектующие'),
       ('Розничная торговля'),
       ('СМИ, маркетинг, реклама, BTL, PR, дизайн, продюсирование'),
       ('Сельское хозяйство'),
       ('Строительство, недвижимость, эксплуатация, проектирование'),
       ('Телекоммуникации, связь'),
       ('Тяжелое машиностроение'),
       ('Управление многопрофильными активами'),
       ('Услуги для бизнеса'),
       ('Услуги для населения'),
       ('Финансовый сектор'),
       ('Химическое производство, удобрения'),
       ('Электроника, приборостроение, бытовая техника, компьютеры и оргтехника'),
       ('Энергетика');

---генератор 1000 работодателей
with test_data(employer_name, num,  area_id) as (
SELECT
    md5(random()::text)         AS employer_name,
    generate_series(1,1000)     AS num,
    floor(random() * 16) + 1    AS area_id)
insert
into employer(employer_name, employer_email, area_id)
select employer_name,
       'employer' || num || '@' ||
        (case (random() * 2)::integer
            when 0 then 'gmail'
            when 1 then 'mail'
            when 2 then 'yahoo'
        end) || '.com',
    area_id
from test_data;

---генератор 10000 вакансий
with test_data as (
    SELECT
        GENERATE_SERIES(1, 10000)           AS id,
        MD5(RANDOM()::TEXT)                 AS vacancy_title,
        FLOOR(RANDOM() * 1000) + 1          AS employer_id,
        MD5(RANDOM()::TEXT)                 AS description,
        ROUND((RANDOM() * 100000)::int,-2)  AS compensation_from,
        (random() > 0.5)                    AS compensation_gross,
        (random() > 0.5)                    AS visible,
        FLOOR(RANDOM() * 16) + 1            AS area_id,
        FLOOR(RANDOM() * 29) + 1            AS specialization_id)
insert into vacancy (vacancy_title,
                     employer_id,
                     description,
                     compensation_from,
                     compensation_to,
                     compensation_gross,
                     visible,
                     area_id,
                     specialization_id,
                     publication_time)
select
    vacancy_title,
    employer_id,
    description,
    compensation_from,
    compensation_from + ROUND((RANDOM() * 10000)::int, -2),
    compensation_gross,
    visible,
    area_id,
    specialization_id,
    CURRENT_TIMESTAMP - RANDOM() * 720 * INTERVAL '1 day'
from test_data;

---генератор 50 000 соискателей
WITH test_data(id, job_seeker_name, job_seeker_birthdate, area_id) AS (
    SELECT
        GENERATE_SERIES(1, 50000) AS id,
        MD5(RANDOM()::TEXT)       AS job_seeker_name,
        '1950-01-01'::date + trunc(random() * 366 * 53)::int AS job_seeker_birthdate,
        FLOOR(RANDOM() * 15) + 1  AS area_id
)
INSERT
INTO job_seeker(job_seeker_name,
                job_seeker_birthdate,
                job_seeker_email,
                area_id)
SELECT
    job_seeker_name,
    job_seeker_birthdate,
    'seeker' || id || '@' ||
    (case (random() * 2)::integer
         when 0 then 'gmail'
         when 1 then 'mail'
         when 2 then 'yahoo'
        end) || '.com',
    area_id
FROM test_data;


---генератор 100 000 резюме
WITH test_data AS (
    SELECT
        GENERATE_SERIES(1, 100000)          AS id,
        MD5(RANDOM()::TEXT)                 AS resume_title,
        FLOOR(RANDOM() * 50000) + 1         AS job_seeker_id,
        ROUND((RANDOM() * 100000)::int,-2)  AS compensation_from,
        (random() > 0.5)                    AS compensation_gross,
        (random() > 0.5)                    AS visible,
        FLOOR(RANDOM() * 16) + 1            AS area_id,
        FLOOR(RANDOM() * 29) + 1            AS specialization_id
)
INSERT
INTO resume(resume_title,
            job_seeker_id,
            compensation_from,
            compensation_to,
            compensation_gross,
            visible,
            area_id,
            specialization_id,
            publication_time)
SELECT
    resume_title,
    job_seeker_id,
    compensation_from,
    compensation_from + + ROUND((RANDOM() * 10000)::int, -2),
    compensation_gross,
    visible,
    area_id,
    specialization_id,
    CURRENT_TIMESTAMP - RANDOM() * 720 * INTERVAL '1 day'
FROM test_data;

---Генератор 100 000 откликов
WITH test_data AS (
    SELECT
        GENERATE_SERIES(1, 10000) AS id,
        (((random() * 100000) ::int) % 10000) + 1 AS resume_id,
        (((random() * 1000000) ::int) % 100000) + 1 AS vacancy_id
)
INSERT INTO response(resume_id,
                     vacancy_id,
                     response_time)
SELECT
    test_data.resume_id,
    test_data.vacancy_id,
    vacancy.publication_time + FLOOR(RANDOM() * 30) * INTERVAL '1 day'
FROM test_data
INNER JOIN vacancy ON test_data.vacancy_id = vacancy.vacancy_id;
