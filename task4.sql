SELECT
    TO_CHAR(TO_DATE ((SELECT date_part('month', publication_time)
                        FROM vacancy
                        GROUP BY date_part('month', publication_time)
                        ORDER BY count(*) DESC
                        LIMIT 1)::text, 'MM'), 'Month') as month_with_max_vacancies,
    TO_CHAR(TO_DATE ((SELECT date_part('month', publication_time)
                      FROM resume
                      GROUP BY date_part('month', publication_time)
                      ORDER BY count(*) DESC
                      LIMIT 1)::text, 'MM'), 'Month') as month_with_max_resume;