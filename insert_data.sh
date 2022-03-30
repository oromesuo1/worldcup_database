#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# Loop for inserting into teams table
TEAMS=("$WINNER" "$OPPONENT")
for TEAM in "${TEAMS[@]}"
do
if [[ $YEAR != year ]]
then
# get the team_id
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM'")

# If not found
if [[ -z $TEAM_ID ]]
then
#insert team
INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM')")
if [[ INSERT_TEAM_RESULT == "INSERT 0 1" ]]
then
echo "Inserted into teams, $TEAM"
fi
# get new team_id
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = $TEAM")

fi

fi
done
####### Inserting into games table section

# Get winner_id from teams table
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
#Get opponentId from Teams table
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
# Inseert into games table
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
if [[ INSERT_GAME_RESULT == "INSERT 0 1"  ]]
then
echo "Inserted game successfully!"
fi

done


