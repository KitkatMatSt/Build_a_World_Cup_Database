#! /bin/bash

#if [[ $1 == "test" ]]
#then
#  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
#else
#  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
#fi

# Do not change code above this line. Use the PSQL variable above to query your database.

PSQL="psql -X --username=yang --dbname=worldcup --no-align --tuples-only -c"
echo $($PSQL "TRUNCATE teams, games")


# the following reads a file passed as the variables line by line:
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS  
do
  if [[ $YEAR != "year" ]]     # skip the header of the csv file
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") # remember single quotes!
    # if not found
    if [[ -z $WINNER_ID ]]   # the above is to avoid repetition/duplication
    then
    # insert team
      $($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")  # insert data in table teams
    fi

    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert team
      $($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    fi

    #WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") # remember single quotes!
    #OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done