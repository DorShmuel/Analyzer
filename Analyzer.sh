#!/bin/bash
############################################################





# functions:
#____________________________________________________________________________
# function MEM creating a directory named memDirectory and executing strings.
#also executing volatility image info printing and using it for Process Tree & Process Scan.
#____________________________________________________________________________

function MEM()
{
	cp ${args[1]} $PWD/memDirectory/${args[1]}
	echo "[+] Memory Directory created "
	echo "[+] Analyzing Memory File"
	echo "_________________________________"
	strings ${args[1]} > $PWD/memDirectory/strings.txt
	cp -r vol $PWD/memDirectory/vol
	cd memDirectory
	cp ${args[1]} $PWD/vol
	cd vol
	echo "Running Volatility imageinfo command "
	echo "____________________________________"
	VAR=$(./vol -f ${args[1]}  imageinfo | grep -i "profile" | awk '{print $4}' | cut -d ',' -f1)
	echo
	echo "memFile Operating System : $VAR "
	echo
	echo "[+]  Running Volatility  Ps Scan & Ps Tree Commands "
	./vol -f ${args[1]}  --profile=$VAR psscan >> $PWD/VolatilityProcessScanLog.txt
	./vol -f ${args[1]} --profile=$VAR pstree >> $PWD/VolatilityProcessTreeLog.txt
	echo "Volatility Done "
	echo "Volatility LOG files created inside vol Directory "

}
args=("$@")

# ________________________________________________________________________________________
# function HDD executing bulk_extractor , strings , binwalk and foremost.
#________________________________________________________________________________________

function HDD()
{
	cp ${args[1]} $PWD/hddDirectory/${args[1]}
	echo " [+] Hdd Directory created "
	echo " [+] Formost output Directory created "
	echo " [+] Analyzing Hdd File with foremost , strings  , Binwalk  And Bulk_Extractor.  "
	echo "_____________________"
	echo
	bulk_extractor -o  Bulk-dir ${args[1]}
	foremost ${args[1]}
        binwalk ${args[1]} >> $PWD/hddDirectory/binwalk.txt
        strings ${args[1]}   >> $PWD/hddDirectory/strings.txt
	mv output $PWD/hddDirectory/foremost
	mv Bulk-dir $PWD/hddDirectory/Bulk

	echo " [*] All Data is saved at hddDirectory you are more then welcome to view them "
 
	echo "________________________________________________________________"

}


# _____________________________________________________________________________
# function LOG saving all the the data inside the created directory.
#_____________________________________________________________________________

function LOG()
{

	if [ ${args[0]} == "hdd" ] || [ ${args[0]} == "HDD" ]
	then
		cd ~
		cd Desktop/hddDirectory
		cp  binwalk.txt log.txt
		cd foremost
		cp audit.txt log1.txt
		echo "[+] binwalk , strings and foremost log.txt was cerated successfully"
		echo "Printing log.txt"
		cat log1.txt
		cd ..
		cat log.txt
		echo "Binwalk, Foremost, Strings & Bulk_Extractor Done And Displayed"
		echo "Thank you"
		echo "________________________________________________________"
	else

		echo "Data Statistics Saved in memDirectory "
		echo "Printing Volatility Ps Scan & Ps Tree "
		cat VolatilityProcessScanLog.txt
		cat VolatilityProcessTreeLog.txt
		echo "Strings txt Created and located in mem Directory"
		echo "Thank You"
		echo "_______________________________"
	fi
}

# ______________________________________________________________________
# function HAND creating memory directory for mem file , and hdd directory for hdd file.
# if mem then make memDirectory and if hdd then make hddDirectory.
#_______________________________________________________________________
function HAND()
{

	if [ ${args[0]} == "mem" ] || [ ${args[0]} == "MEM" ]
	then
		mkdir memDirectory
		MEM

	elif [ ${args[0]} == "hdd" ] || [ ${args[0]} == "HDD" ]
	then
		mkdir hddDirectory
		HDD
	else
		echo "file is not hdd or mem"
		exit

	fi

}


args=("$@")
HAND
LOG
								#Thank You !
