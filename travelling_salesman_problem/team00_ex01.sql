DROP TABLE IF EXISTS travel_cost;

CREATE TABLE IF NOT EXISTS
    travel_cost AS (
  SELECT
    'a' AS point1, 'b' AS point2, 10 AS cost
);

INSERT INTO travel_cost VALUES
    ('a', 'c', 15),
    ('a', 'd', 20),
    ('b', 'a', 10),
    ('b', 'c', 35),
    ('b', 'd', 25),
    ('c', 'a', 15),
    ('c', 'b', 35),
	('c', 'd', 30),
    ('d', 'a', 20),
    ('d', 'b', 25),
    ('d', 'c', 30);

WITH RECURSIVE
    tsp(tour, last_point, total_cost, i) AS (
        SELECT -- starting point
            '{a,',
            'a',
            0,
            0
        UNION ALL
        SELECT -- iterate recursively
            tsp.tour || travel_cost.point2 || ',',
            travel_cost.point2,
            tsp.total_cost + travel_cost.cost,
            tsp.i + 1
        FROM
            tsp,
            travel_cost
        WHERE
            tsp.last_point = travel_cost.point1
        AND
            POSITION(travel_cost.point2 IN tsp.tour) = 0
    ),
tours AS (
SELECT
    tsp.total_cost + (SELECT cost FROM travel_cost
                      WHERE point1 = tsp.last_point
                      AND point2 = 'a') AS total_cost,
    tsp.tour || 'a}' AS tour
FROM
    tsp
WHERE
    tsp.i = (SELECT MAX(i) FROM tsp)
)
SELECT
    *
FROM
    tours
WHERE
    tours.total_cost = (SELECT MIN(total_cost) FROM tours)
OR
    tours.total_cost = (SELECT MAX(total_cost) FROM tours)
ORDER BY
    1, 2
