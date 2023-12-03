SELECT vacancy.vacancy_id, vacancy_title
FROM vacancy
INNER JOIN response ON vacancy.vacancy_id = response.vacancy_id and response_time - publication_time <= 7 * INTERVAL '1 day'
GROUP BY vacancy.vacancy_id
HAVING count(resume_id) > 5;
