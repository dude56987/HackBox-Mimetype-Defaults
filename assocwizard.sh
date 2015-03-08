#! /bin/bash
# script to change assocation for a given mimetype
# user gives one argument for a single file
fileName=$1;
# figure out the file given mimetype
fileType=$(xdg-mime query filetype $fileName);
currentDefault=$(xdg-mime query default $fileType);
counter=1
list="###############################################################################";
list+="\nDecide on what you want to open the filetype with and hit q to close this list.";
list+="\n###############################################################################\n";
for i in $(ls /usr/share/applications/);do
	list+=$i;
	list+=" ";
	if [ $counter -gt 5 ];then
		counter=0;
		list+="\n";
	fi
	counter=$[counter+1];
done
list+="\n###############################################################################";
list+="\nDecide on what you want to open the filetype with and hit q to close this list.";
list+="\n###############################################################################";
# allow the user to pick the new thing to set the file to be assocated with
echo "###############################################"
echo "$fileType is currently set to open with $currentDefault";
echo "Type 'help' for more options."
echo "###############################################"
echo "What would you like to assocate $fileType with?"
echo -n ">>> "
read userChoice;
if [ $userChoice == "help" ];then
	echo "Type 'list' to view all posible assocations."
	echo "Type 'exit' to close the program."
	# recursive call to this script
	bash $0 $fileName
	exit
fi
if [ $userChoice == "list" ];then
	echo -e "$list" | sed -e "s/\.desktop//g" | less;
	# recursive call to this script
	bash $0 $fileName
	exit
fi
if [ $userChoice == "exit" ];then
	echo "Wizard will now exit...";
	exit
fi
userChoice=$userChoice".desktop"
echo "You have chosen to assocate $fileType with $userChoice is this what you want to do?"
echo -n "[y/n]: "
read yesNo
if [ $yesNo == "y" ];then
	xdg-mime default $userChoice $fileType
	echo "Checking work..."
	fileType=$(xdg-mime query filetype $fileName);
	currentDefault=$(xdg-mime query default $fileType);
	echo "$fileType is now set to open with $currentDefault";
fi

