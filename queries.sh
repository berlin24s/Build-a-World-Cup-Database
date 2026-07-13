#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"


# Total number of goals in all games from winning teams:
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

# Total number of goals in all games from both teams combined:
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

# Average number of goals in all games from the winning teams:
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

# Average number of goals in all games from the winning teams rounded to two decimal places:
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

# Average number of goals in all games from both teams:
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

# Most goals scored in a single game by one team:
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

# Number of games where winning team scored more than two goals:
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

# Winner of the 2018 tournament team name:
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON teams.team_id = games.winner_id WHERE year = 2018 AND round = 'Final'")"

# List of teams who played in the 2014 'Eighth-Final' round:
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN (SELECT winner_id FROM games WHERE year = 2014 AND round = 'Eighth-Final' UNION SELECT opponent_id FROM games WHERE year = 2014 AND round = 'Eighth-Final') ORDER BY name")"

# List of unique winning team names in the whole data set:
echo "$($PSQL "SELECT DISTINCT name FROM teams INNER JOIN games ON teams.team_id = games.winner_id ORDER BY name")"

# Year and team name of all the champions:
echo "$($PSQL "SELECT year, name FROM games INNER JOIN teams ON games.winner_id = teams.team_id WHERE round = 'Final' ORDER BY year")"

# List of teams that start with 'Co':
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%' ORDER BY name")"