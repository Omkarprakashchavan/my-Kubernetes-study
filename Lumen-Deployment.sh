#!/bin/bash
# Maintainer Lumen-Terrain Team
# Developer Omkar.Chavan@bhge.com

# Variable Setting
temp='/tmp/lumen-terrain'
dt=`date +"%d-%m-%Y"`
dir='/var/lumen-terrain'
echo -e "######################################################################################################################\n"
echo -e "\t\t\t\t\t Starting Deployment for Lumen Terrain Application\n"
echo -e "######################################################################################################################\n"

if [ ! -f $temp/dist*.zip ]
then
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t No dist*.zip found at /tmp/lumen-terrain/\n"
	echo -e "\t\t\t\t\t Skipping Deployment of Front-End build \n"
	echo -e "######################################################################################################################\n"
else
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 1.1) Deleting OLD backups of Front-End Build\n"
	rm -rf $dir/lumen-terrain-dashboard-app_* || echo -e "no old dist backups available\n"
	echo -e "\t\t\t\t\t 1.2) Taking Backup of OLD Front-End build\n"
	mv lumen-terrain-dashboard-app lumen-terrain-dashboard-app_"$dt" || echo -e "No lumen-terrain-dashboard-app Directory available\n"
	echo -e "\t\t\t\t\t 1.3) Moving DIST.*ZIP files from /tmp/lumen-terrain to /var/lumen-terrain\n"
	mv $temp/dist*.zip $dir/
	echo -e "\t\t\t\t\t 1.4) Extracting DIST-*.zip in /var/lumen-terrain \n"
	echo -e "######################################################################################################################\n"
	unzip $dir/dist*.zip 
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t 1.5) Copying Environment.js file from OLD backup to new\n"
    cat $dir/lumen-terrain-dashboard-app_"$dt"/assets/env.js > $dir/lumen-terrain-dashboard-app/assets/env.js
	echo -e "\t\t\t\t\t 1.6) Deleting the DIST-*.ZIP files from /var/lumen-terrain \n"
	rm -rf $dir/dist-*.zip
    build_present="True"
	echo -e "######################################################################################################################\n"
fi

if [ ! -f $temp/build*.zip ]
then
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t No build*.zip found at /tmp/lumen-terrain/ \n"
	echo -e "\t\t\t\t\t Skipping Deployment of Back-End build \n"
	echo -e "######################################################################################################################\n"
else	
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 2.1) Deleting OLD backups of Back-End Build \n"
	rm -rf $dir/build_* || echo -e "no old Build backups available\n"
	echo -e "\t\t\t\t\t 2.2) Taking Backup of OLD Back-End build \n"
	mv build build_"$dt" || echo -e "No build Directory available\n"
	echo -e "\t\t\t\t\t 2.3) Moving Build.*ZIP files from /tmp/lumen-terrain to /var/lumen-terrain \n"
	mv $temp/build*.zip $dir/
	echo -e "\t\t\t\t\t 2.4) Extracting Build-*.zip in /var/lumen-terrain \n"
	echo -e "######################################################################################################################\n"
	unzip $dir/build*.zip -d build 
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 2.5) Deleting the Build-*.ZIP files from /var/lumen-terrain \n"
	rm -rf $dir/build-*.zip
	echo -e "\t\t\t\t\t 2.6) Copy Configuration files from Backup \n"
	cp -f $dir/build_"$dt"/.env $dir/build/ || echo -e "No Old .ENV files are found \n"
	cp -f $dir/build_"$dt"/src/config/config.json $dir/build/src/config/ || echo -e "No old config.json found\n"
    build_present="True"
	echo -e "######################################################################################################################\n"
fi

if [ "$build_present" == "True" ]
then
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t Install NPM Packages \n"
    cd $dir/build
    npm install --production
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t Restart Lumen-Terrain Service \n"
    systemctl stop lumen-terrain
    sleep 2s
    systemctl start lumen-terrain
	if [ "$?" -eq "0" ]
	then
		echo -e "\t\t\t\t\t \033[32mLumen-Terrain service restarted Successfully \e[0m""\n"
	else
		echo -e "\t\t\t\t\t \033[31mError While restarting the lumen-terrain Service\e[0m""\n"
	fi
	echo -e "######################################################################################################################\n"
else
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t \033[95mNo build and dist files found at /tmp/lumen-terrain/ for installation \e[0m""\n"
	echo -e "######################################################################################################################\n"
fi