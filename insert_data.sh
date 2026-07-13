#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi


$PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY;" > /dev/null

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip the CSV header
  if [[ $YEAR != "year" ]]
  then
    # Insert both teams if they do not already exist,
    # then insert the game using IDs obtained from teams.
    $PSQL "
      INSERT INTO teams(name)
      VALUES('$WINNER'), ('$OPPONENT')
      ON CONFLICT(name) DO NOTHING;

      INSERT INTO games(
        year,
        round,
        winner_id,
        opponent_id,
        winner_goals,
        opponent_goals
      )
      SELECT
        $YEAR,
        '$ROUND',
        winner.team_id,
        opponent.team_id,
        $WINNER_GOALS,
        $OPPONENT_GOALS
      FROM teams AS winner
      CROSS JOIN teams AS opponent
      WHERE winner.name = '$WINNER'
        AND opponent.name = '$OPPONENT';
    " > /dev/null
  fi
done