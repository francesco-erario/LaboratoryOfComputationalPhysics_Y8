#!/bin/bash

cd $HOME/anaconda_projects/LaboratoryOfPhysicsOfData_Y8

# a) Copyng data payload in a file data.txt
# "grep -v "^#" data.csv | cut -f6 -d "," > data.txt" –> mi mette in colonna un numero per volta
grep -v "^#" data.csv | sed 's/,/\t/g' > data.txt

#b)
even_counter=0
while IFS=$'\t' read -r element; do # reads the file line by line separating line element with \t (but takes the whole line)
    for num in $element; do
        (( $num % 2 == 0 )) && (( even_counter++ ))
    done
done < data.txt
echo "The count of even numbers is $even_counter"

#c)
group1=0
group2=0
comp=$( echo "scale=3; 100*sqrt(3)/2" | bc -l )
while IFS=$'\t' read -r X Y Z _; do # "_" ignores the rest of the line (also cut ... can be used at the end)
    d=$( echo "scale=3; sqrt($X^2 + $Y^2 + $Z^2)" | bc -l )
    if (( $(echo "$d > $comp" | bc -l) )); then
        ((group1++))
    else
        ((group2++))
    fi
done < data.txt
echo "Number of elements in group 1: $group1"
echo "Number of elements in group 2: $group2"

#d)
if [ -z "$1" ]; then
    echo "This script requires as input a natural number"
    exit 1 # error code
fi

mkdir -p data_div

for (( i=1; i<=$1; i++ )); do

    while IFS=$'\t' read -r X Y Z Xp Yp Zp; do # reads the file line by line separating line element with \t
        # risultato=$( echo "scale=3; $num / $i" | bc )
        # echo "$risultato" >> data_div/$i.txt –––> inserisce i risultati in una colonna
        echo -e "$(echo "scale=3; $X/$i" | bc)\t$(echo "scale=3; $Y/$i" | bc)\t$(echo "scale=3; $Z/$i" | bc)\t$(echo "scale=3; $Xp/$i" | bc)\t$(echo "scale=3; $Yp/$i" | bc)\t$(echo "scale=3; $Zp/$i" | bc)\t" >> data_div/"$i.txt"
    done < data.txt
    
done