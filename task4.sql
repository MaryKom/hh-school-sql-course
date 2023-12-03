--- Случайно сначала решила, чтобы в каждом году выводился самый популярный месяц. Было потно)
SELECT table1.year, to_char(to_timestamp (month_with_max_vacancies::text, 'MM'), 'month') as month_with_max_vacancies, to_char(to_timestamp (month_with_max_resume::text, 'MM'), 'month') as month_with_max_resume
FROM
    (SELECT t1.year,  t1.month as month_with_max_vacancies
    FROM    (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
             FROM vacancy
             GROUP BY month, year
             ORDER BY count(*) DESC) as t1
                INNER JOIN
            (   SELECT  t1.year, MAX(t1.cnt) as mmax
                FROM (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
                      FROM vacancy
                      GROUP BY month, year
                      ORDER BY count(*) DESC) as t1
                GROUP BY t1.year
            ) as t2
            ON t2.year = t1.year AND t2.mmax = t1.cnt
    ORDER BY t1.year) as table1
    INNER JOIN
    (SELECT t1.year,  t1.month as month_with_max_resume
     FROM    (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
              FROM resume
              GROUP BY month, year
              ORDER BY count(*) DESC) as t1
                 INNER JOIN
             (   SELECT  t1.year, MAX(t1.cnt) as mmax
                 FROM (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
                       FROM resume
                       GROUP BY month, year
                       ORDER BY count(*) DESC) as t1
                 GROUP BY t1.year
             ) as t2
             ON t2.year = t1.year AND t2.mmax = t1.cnt
     ORDER BY t1.year) as table2
        ON table1.year = table2.year;

--- Решение при котором из всех годов выбирается только один самый популярный месяц
SELECT table1.month_with_max_vacancies, table2.month_with_max_resume
FROM
    (SELECT (to_char(to_timestamp (t1.month::text, 'MM'), 'month') || t1.year::text) as month_with_max_vacancies
     FROM    (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
              FROM vacancy
              GROUP BY month, year
              ORDER BY count(*) DESC) as t1
                 INNER JOIN
             (   SELECT  t1.year, MAX(t1.cnt) as mmax
                 FROM (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
                       FROM vacancy
                       GROUP BY month, year
                       ORDER BY count(*) DESC) as t1
                 GROUP BY t1.year
             ) as t2
             ON t2.year = t1.year AND t2.mmax = t1.cnt
     LIMIT 1) table1,
    (SELECT (to_char(to_timestamp (t1.month::text, 'MM'), 'month') || t1.year::text) as month_with_max_resume
     FROM    (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
              FROM resume
              GROUP BY month, year
              ORDER BY count(*) DESC) as t1
                 INNER JOIN
             (   SELECT  t1.year, MAX(t1.cnt) as mmax
                 FROM (SELECT date_part('month', publication_time) as month, date_part('year', publication_time) as year, count(*) as cnt
                       FROM resume
                       GROUP BY month, year
                       ORDER BY count(*) DESC) as t1
                 GROUP BY t1.year
             ) as t2
             ON t2.year = t1.year AND t2.mmax = t1.cnt
     LIMIT 1) table2;
