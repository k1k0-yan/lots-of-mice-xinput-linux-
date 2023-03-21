#!/bin/bash

trap ctrl_c INT

ctrl_c() {
	for ((i=1; i < $sums; i++))
	do
		xinput reattach ${id_mouse[$i]} "Virtual core pointer"
		xinput remove-master "test$i pointer"
	done
	kill -term $$
}


mouse() {
	xinput list > test.txt
	id_mouse=()
	let sums=0

	while read line; do
		if [ "$(echo $line | grep 'slave pointer' | grep -v 'Virtual core')" ]; then
			let sums++
			id_mouse+=( $(echo $line | awk '{ print $6 }' | cut -f2 -d"=") )
		fi
	done < test.txt
}

mouse

###### тут будем добавлять группы

for ((i=1; i < $sums; i++))
do
	xinput create-master test$i
	xinput reattach ${id_mouse[$i]} "test$i pointer"
done

for (( ;; ))
do
	sleep 1
done

