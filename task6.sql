-- для таблиц area и specialization не имеет смысла делать индексы,
-- они сами по себе очень маленькие

-- индексы для работодателей по поиску по городу и специализации, по дате публикации
CREATE INDEX resume_area_id_index ON resume (area_id, specialization_id);
CREATE INDEX resume_publication_time_index ON resume (publication_time DESC);

-- индексы для сосикателей по наименованию вакансии, зарплате и дате публикации
CREATE INDEX vacancy_title_index ON vacancy (vacancy_title);
CREATE INDEX vacancy_compensation_index ON vacancy (compensation_from, compensation_to);
CREATE INDEX vacancy_publication_time_index ON vacancy (publication_time DESC);

-- индекс для подсчета откликов в определенный интервал времени
CREATE INDEX  response_response_time_index ON response (response_time);

-- Возможно часто применяется поиск по наименованию компаний:
CREATE INDEX employer_employer_name_index ON employer (employer_name);
