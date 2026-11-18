-- Find the most popular greetings this week.
SELECT language, COUNT(*) AS total
FROM greetings
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY language
HAVING COUNT(*) > 1
ORDER BY total DESC;
