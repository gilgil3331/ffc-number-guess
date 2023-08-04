#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo $($PSQL "CREATE DATABASE number_guess();")
echo $($PSQL "CREATE TABLE users();")
echo $($PSQL "ALTER TABLE users ADD COLUMN user_id SERIAL PRIMARY KEY;")
echo $($PSQL "ALTER TABLE users ADD COLUMN username VARCHAR(40) UNIQUE;")
echo $($PSQL "ALTER TABLE users ADD COLUMN games_played INT;")
echo $($PSQL "ALTER TABLE users ADD COLUMN best_game INT;")
