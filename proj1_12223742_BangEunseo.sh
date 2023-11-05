#! /bin/bash
echo "---------------------------"
echo -n "User Name: "
read userName
echo -n "Student Number: "
read studentNumber
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release data' in 'u.item'"
echo "7. Get the data of movies rated by specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

ITEM_FILE="./ossprj1/$1"

while true
do
	read -p "Enter your choice [ 1-9 ] " choice
	echo -e "\n"
	case $choice in
        	1)
                	read -p "Please enter 'movie id' (1~1682) : " in
			echo -e "\n"

                	num="$in"
                	cat ./$1 | awk -F"|" -v num="$in" '$1 == num {print $0}'
                	;;
        	2)
                	read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n) : " in2

                	if [ "$in2" = "y" ]
                	then
				echo -e "\n"
                        	cat ./$1 | awk -F"|" '$7==1 {print $1, $2}' | sort -n | head -n 10
                	fi
                	;;
        	3)
                	read -p "Please enter the 'movie id' (1~1682) : " in3

			echo -e "\n"
			echo -e -n "average rating of 1: "

			numm="$in3"
                	cat ./$2 | awk -F"\t" -v numm="$in3" '$2 == numm {sum += $3; count++}; END {print sum/count}'
                	;;
		4)
                	read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" in4
                	if [ "$in4" = "y" ]
                	then
				cat ./$1 | sed -e 's/http.*)//g' | head -n 10
                	fi
			;;
		5)
			read -p "Do you want to get the data about users from 'u.user'?(y/n) : " in5

			if [ "$in5" = "y" ]
			then
				echo -e "\n"
				cat ./$3 | sed -e 's/M/male/g' -e 's/F/female/g' | awk -F"|" '{printf "User %s is %s years old %s %s\n", $1, $2, $3, $4}' | head -n 10
			fi
			;;
		6)
			read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n) : " in6

			if [ "$in6" = "y" ]
			then
				cat ./$1 | tail -n 10 | sed -e 's/Jan/01/g' -e 's/Feb/02/g' -e 's/Mar/03/g' -e 's/Apr/04/g' -e 's/May/05/g' -e 's/JUN/06/g' -e 's/Jul/07/g' -e 's/Aug/08/g' -e 's/Sep/09/g' -e 's/Oct/10/g' -e 's/Nov/11/g' -e 's/Dec/12/g' | sed 's/\(..\)-\(..\)-\(....\)/\3\1\2/'
			fi
			;;
		7)
			read -p "Please enter the 'user id' (1~943) : " in7
			echo -e "\n"

			num7="$in7"
			MYFILE=$(cat ./$2 | sort -k 2 -g | awk -F"\t" -v num7="$in7" '$1 == num7 {printf "%d|", $2}' | sed 's/.$//')
			echo $MYFILE
			echo -e "\n"

			IFS="|" read -r -a arr <<< "$MYFILE"

			for value in "${arr[@]:0:10}"
			do
				cat ./$1 | awk -F"|" -v idx="$value" '$1 == idx {printf "%s|%s\n", $1, $2}'
			done

			;;
		8)
			read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) : " in8

			twenyUser=$(cat ./$3 | awk -F"|" '$2 >= 20 && $2 <= 29 {printf "%d ", $1}')

			IFS=" " read -r -a twenyId_arr <<< "$twenyUser"

			twenyData=""
			sum=()
			count=()
			index=0
			for value in "${twenyId_arr[@]}"
			do
				#twenyData+=$(cat ./$2 | awk -F"\t" -v vl="$value" '$1 == vl {printf "%s %s\n", $2, $3}')
				cat ./$2 | awk -F"\t" -v vl="$value" '$1 == vl' {
			done


			for i in "${1:1655}"
			do
				rate=$(twenyData | awk -v idx="$i" '$1 == idx {print $2}')
				sum[$in]+=$rate
				count[$in]+=1
			done


			for i in "${1:1655}"
			do
				avg=sum[$in]/count[$in]
				echo "$i $avg$'\n'"
			done
			;;
		9)
			echo "Bye!"
			break
			;;
	esac
	echo -e "\n"
done
