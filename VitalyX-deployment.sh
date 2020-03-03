#!/bin/bash
# Maintainer Vitalyx Team
# Developer Omkar.Chavan@bhge.com

# Variable Setting
temp='/tmp/vitalyx'
dt=`date +"%d-%m-%Y"`
dir='/var/vitalyx'
echo -e "######################################################################################################################\n"
echo -e "\t\t\t\t\t Starting Deployment for VitalyX Application\n"
echo -e "######################################################################################################################\n"

if [ ! -f $temp/client*.zip ]
then
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t No client*.zip found at /tmp/vitalyx/\n"
	echo -e "\t\t\t\t\t Skipping Deployment of Front-End build \n"
	echo -e "######################################################################################################################\n"
else
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 1.1) Deleting OLD backups of Front-End Build\n"
	rm -rf $dir/vitalyx-client_* || echo -e "no old client backups available\n"
	echo -e "\t\t\t\t\t 1.2) Taking Backup of OLD Front-End build\n"
	mv vitalyx-client vitalyx-client_"$dt" || echo -e "No vitalyx-client Directory available\n"
	echo -e "\t\t\t\t\t 1.3) Moving client.*ZIP files from /tmp/vitalyx to /var/vitalyx\n"
	mv $temp/client*.zip $dir/
	echo -e "\t\t\t\t\t 1.4) Extracting client-*.zip in /var/vitalyx \n"
	echo -e "######################################################################################################################\n"
	unzip $dir/client*.zip 
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t 1.5) Copying Environment.js file from OLD backup to new\n"
    cat $dir/vitalyx-client_"$dt"/assets/env.js > $dir/vitalyx-client/assets/env.js
	echo -e "\t\t\t\t\t 1.6) Deleting the client-*.ZIP files from /var/vitalyx \n"
	rm -rf $dir/client-*.zip
    build_present="True"
	echo -e "######################################################################################################################\n"
fi

if [ ! -f $temp/service*.zip ]
then
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t No service*.zip found at /tmp/vitalyx/ \n"
	echo -e "\t\t\t\t\t Skipping Deployment of Back-End service \n"
	echo -e "######################################################################################################################\n"
else	
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 2.1) Deleting OLD backups of Back-End service \n"
	rm -rf $dir/service_* || echo -e "no old service backups available\n"
	echo -e "\t\t\t\t\t 2.2) Taking Backup of OLD Back-End service \n"
	mv service service_"$dt" || echo -e "No service Directory available\n"
	echo -e "\t\t\t\t\t 2.3) Moving service.*ZIP files from /tmp/vitalyx to /var/vitalyx \n"
	mv $temp/service*.zip $dir/
	echo -e "\t\t\t\t\t 2.4) Extracting service-*.zip in /var/vitalyx \n"
	echo -e "######################################################################################################################\n"
	unzip $dir/service*.zip -d service 
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 2.5) Deleting the service-*.ZIP files from /var/vitalyx \n"
	rm -rf $dir/service-*.zip
	echo -e "\t\t\t\t\t 2.6) Copy Configuration files from Backup \n"
    cp -f $dir/service_"$dt"/.env $dir/service/ || echo "No Old .ENV files are found"
	cp -f $dir/service_"$dt"/src/config/config.json $dir/service/src/config/ || echo -e "No old config.json found\n"
    build_present="True"
	echo -e "######################################################################################################################\n"
fi

if [ "$build_present" == "True" ]
then
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t Install NPM Packages \n"
    cd $dir/service
    npm install --production
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t\t Restart vitalyx Service \n"
    systemctl stop vitalyx-lube
    sleep 2s
    systemctl start vitalyx-lube
	if [ "$?" -eq "0" ]
	then
		echo -e "\t\t\t\t\t \033[32mvitalyx service restarted Successfully \e[0m""\n"
	else
		echo -e "\t\t\t\t\t \033[31mError While restarting the vitalyx Service\e[0m""\n"
	fi
	echo -e "######################################################################################################################\n"
else
	echo -e "######################################################################################################################\n"
    echo -e "\t\t\t\t \033[95mNo Client-*.zip and service-*.zip files found at /tmp/vitalyx/ for installation \e[0m""\n"
	echo -e "######################################################################################################################\n"
fi