#!/bin/bash

echo -en "Please guess the magic number: " #-en tells echo not to add linebreak
read X
echo $X | grep "[^0-9]" > /dev/null 2>&1 # grep [^0-9] finds only those lines which don't consist only of numbers
if [ "$?" -eq "0" ]; then
	# If the grep found something other than 0-9
	# then it's not an integer.
	echo "Sorry, wanted a number"
else
	# The grep found only 0-9, so it's an integer. 
	# We can safely do a test on it.
	if [ "$X" -eq "7" ]; then
		echo "You entered the magic number!"
	else
		echo "$X isnt the magic number, try again"
	fi
fi
