SELECT
    area.area_id,
    area.area_name,
    avg(compensation_from *
        (CASE
              WHEN compensation_gross
                  THEN 0.87
              ELSE 1
            END
            ))::bigint AS average_compensation_from,
    avg(compensation_to *
        (CASE
              WHEN compensation_gross
                  THEN 0.87
              ELSE 1
            END
            ))::bigint AS average_compensation_to,
    avg((compensation_to + compensation_from) *
        (CASE
                  WHEN compensation_gross
                      THEN 0.87
                  ELSE 1
            END
            )/ 2)::bigint AS average_compensation
FROM vacancy, area
WHERE vacancy.area_id = area.area_id
GROUP BY area.area_id, area.area_name
ORDER BY area_id;
