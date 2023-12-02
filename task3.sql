SELECT
    area.area_id,
    area.area_name,
    avg(compensation_from) AS average_compensation_from,
    avg(compensation_to) AS average_compensation_to,
    avg((compensation_to + compensation_from) / 2) AS average_compensation
FROM vacancy, area
WHERE vacancy.area_id = area.area_id
GROUP BY area.area_id, area.area_name
ORDER BY area_id;