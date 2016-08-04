#!/bin/bash
#
# This is a sample "gameserver" that answers with a quote to new connections.
# This game assumes you are the only player and that you don't make more than 
# one request per second :) Have fun
#

# include config
source $(dirname $0)/gameserver.conf

#variables
LISTEN_PORT=8080
QUOTES_DIR=$(dirname $0)/quotes
QUOTE_NUMBER=227
QUOTE_RANDOM_NUMBER=$(shuf -i 0-$QUOTE_NUMBER -n 1)
WELCOME_MESSAGE_PERIODICITY=5
WELCOME_MESSAGE="
Hey there! 
Welcome to the Quote gameserver. Not quite a game, but will do the job! 
This is an automatic message from:
$hostname -> [$host]
We share our dirty secrets through port ${port}. Port is blocked though.
Just to let you know, SSL is set to $ssl and Authentication to $authenticate.
Connect again for a quote. Have a nice quoting day!
-- The Quote Gameserver
"

# Control variable to enforce periodicity in loop
X=$(expr $WELCOME_MESSAGE_PERIODICITY + 1)
X=$(shuf -i 0-$X -n 1)

# send a quote on each connection forever
while true; do 
	
# show welcome message
	if [ "$X" == $(expr $WELCOME_MESSAGE_PERIODICITY + 1) ]; then
		echo -e "$WELCOME_MESSAGE" | nc -lp $LISTEN_PORT -vq0
		X=0
	else # print a quote
		cat ${QUOTES_DIR}/quote${QUOTE_RANDOM_NUMBER}.txt | nc -lp $LISTEN_PORT -vq0
		QUOTE_RANDOM_NUMBER=$(shuf -i 0-$QUOTE_NUMBER -n 1)
	fi
	
	X=$(expr $X + 1)

done
