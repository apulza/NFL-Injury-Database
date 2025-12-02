
-- How many injuries are there per team?
SELECT t.team_name, t.conference, t.division, COUNT(*) AS total_injuries
FROM injury i
JOIN player_on_team pot ON i.player_id = pot.player_id
JOIN team t ON pot.team_id = t.team_id
GROUP BY t.team_id, t.team_name, t.conference, t.division
ORDER BY total_injuries DESC;

-- How many wins did each team get?

SELECT t.team_name, COUNT(g.winning_team_id) AS total_wins
FROM team t
LEFT JOIN game g ON t.team_id = g.winning_team_id
GROUP BY t.team_id, t.team_name
ORDER BY total_wins DESC;

-- How many distinct players got injured per team?

SELECT t.team_name, t.conference, t.division, COUNT(DISTINCT i.player_id) AS distinct_injured_players
FROM injury i
JOIN player_on_team pot ON i.player_id = pot.player_id
JOIN team t ON pot.team_id = t.team_id
GROUP BY t.team_id, t.team_name, t.conference, t.division
ORDER BY distinct_injured_players DESC;

-- What are the most common injuries?

SELECT injury, COUNT(*) AS occurrence_count
FROM injury
GROUP BY injury
ORDER BY occurrence_count DESC
LIMIT 10;

-- How many total injuries per week?

SELECT w.week_id, COUNT(i.player_id) AS total_injuries
FROM week w
LEFT JOIN injury i ON w.week_id = i.week_id
GROUP BY w.week_id
ORDER BY w.week_id;

-- What are the top 5 most injuries by age?


SELECT TIMESTAMPDIFF(YEAR, p.dob, w.start_date) AS age, COUNT(*) AS injury_count
FROM injury i JOIN player p USING (player_id) JOIN week w USING (week_id)
GROUP BY age
ORDER BY injury_count DESC
LIMIT 5;

-- What 5 most common injuries by position?

SELECT pt.position, COUNT(*) AS injury_count
FROM player_on_team pt JOIN injury i USING (player_id)
GROUP BY pt.position
ORDER BY injury_count DESC
LIMIT 5;

-- What are the proportions for each injury status?

SELECT game_status, COUNT(*) AS count, 
ROUND(COUNT(*) / (SELECT COUNT(*) FROM injury), 4) AS proportion
FROM injury
GROUP BY game_status
ORDER BY proportion DESC;

