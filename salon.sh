#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=salontest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
fi

ECHO_SERVICES() {
  SERVIES=$($PSQL "select * from services")
  echo "$SERVIES" | while IFS="|" read SERVICE_ID NAME
  do 
    echo -e "$SERVICE_ID) $NAME"
  done
}

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

ECHO_SERVICES

read SERVICE_ID_SELECTED
DB_SERVICE_ID=$($PSQL "select service_id from services where service_id = $SERVICE_ID_SELECTED")
while [[ -z $DB_SERVICE_ID ]]
do
  echo -e "I could not find that service. What would you like today?"
  ECHO_SERVICES
  read SERVICE_ID_SELECTED
  DB_SERVICE_ID=$($PSQL "select service_id from services where service_id = $SERVICE_ID_SELECTED")
done

echo -e "\nWhat's your phone number?"
read  CUSTOMER_PHONE
DB_CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
if [[ -z $DB_CUSTOMER_NAME ]]
then 
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  RES=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi

echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
RES=$($PSQL "insert into appointments (customer_id, service_id, time) values ($CUSTOMER_ID, $DB_SERVICE_ID, '$SERVICE_TIME')")

SERVICE_NAME=$($PSQL "select name from services where service_id=$DB_SERVICE_ID")
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
