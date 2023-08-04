#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read username

randomNumber=$(echo $(( RANDOM % 1001 )))
isNumber() {
  # Check if the input is numeric using a regular expression
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    return 0  # Return 0 (true) if the input is a number
  else
    return 1  # Return 1 (false) if the input is not a number
  fi
}
usernameFromDatabase=$($PSQL "SELECT * FROM users WHERE username='$username';")

if [[ -z $usernameFromDatabase ]]; then
  #User doesn't exist
  $PSQL "INSERT INTO users(username) VALUES('$username');"
  echo "Welcome, $username! It looks like this is your first time here."
else
  games_played=$($PSQL "SELECT games_played FROM users WHERE username='$username';")
  best_game=$($PSQL "SELECT best_game FROM users WHERE username='$username';")
  echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

games_played_incremented=$((games_played + 1))
echo $($PSQL "UPDATE users SET games_played = $games_played_incremented WHERE username='$username';")

echo "Guess the secret number between 1 and 1000:"
read userInput

echo "psss, number it $randomNumber"
guessAttempts=1

until isNumber "$userInput" && [ "$userInput" -eq "$randomNumber" ]; do
    if ! isNumber "$userInput"; then
        echo "That is not an integer, guess again:"
    elif [ "$userInput" -lt "$randomNumber" ]; then
        echo "It's higher than that, guess again:"
    elif [ "$userInput" -gt "$randomNumber" ]; then
        echo "It's lower than that, guess again:"
    fi
    ((guessAttempts++))
    
    if [ -z "$usernameFromDatabase" ] || [ "$guessAttempts" -le "$best_game" ]; then
      $PSQL "UPDATE users SET best_game = $guessAttempts WHERE username='$username';"
    fi

    read userInput
done

echo "You guessed it in $guessAttempts tries. The secret number was $randomNumber. Nice job!"
