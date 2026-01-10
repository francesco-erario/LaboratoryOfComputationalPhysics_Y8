
#!/bin/bash

cd $HOME

# a)
# make students directory
mkdir -p $HOME/students
# download file from URL
# -O allowes to change the filename directly
# be careful putting & at the end of the url that means to download in background ––> bugs on the flow of the script
wget -O LCP_students.csv https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7
# One can also use wget and than mv

# check wether the file already is inside the directory, if not copy inside of it
if [ -f "./students/LCP_students.csv" ]
then
    echo "The file ./students/LCP_students.csv already exists."
else 
    cp LCP_students.csv ./students/
fi

# b)
# create 2 new files in the students directory
touch ./students/PoD_stud.csv
touch ./students/Phys_stud.csv

# c,d)
# case-insensitive search 
grep -i "physics" ./students/LCP_students.csv > ./students/Phys_stud.csv 
grep -i "pod" ./students/LCP_students.csv > ./students/PoD_stud.csv 

cd students

max_count_PoD=0
letter_PoD=""
for i in {A..Z}; do
    n=$( grep -c "^$i" PoD_stud.csv ) # -c counts the number of lines matching the requirement (also displays the result)
    echo "Number of lines starting with $i in PoD: $n"
    if [ "$n" -gt "$max_count_PoD" ]; then 
        max_count_PoD=$n
        letter_PoD=$i
    fi
done

echo "\n"

max_count_Phys=0
letter_Phys=""
for i in {A..Z}; do
    n=$( grep -c "^$i" Phys_stud.csv )
    echo "Number of lines starting with $i in Physics: $n"
    if [ "$n" -gt "$max_count_Phys" ]; then 
        max_count_Phys=$n
        letter_Phys=$i
    fi
done

echo "The letter with most counts in PoD is: $letter_PoD"
echo "The letter with most counts in Phys is: $letter_Phys"

# e)
counter=1
while IFS= read -r line; do # reads the file line by line without trimming
    if [ $counter -eq 1 ]; then 
        ((counter++))
        continue 
    fi
    group=$(( (counter - 1) % 18 + 1 ))
    echo "$line" >> "group_$group.txt"
    ((counter++))
done < LCP_students.csv

