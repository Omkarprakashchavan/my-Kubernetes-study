#!/bin/bash
# Maintainer Vitalyx Team
# Developer Omkar.Chavan@bhge.com
#set -x
# Variable Setting
temp='/home/bh_vitalyx/file-transfer'
dt=`date +"%d-%m-%Y"`
dir='/home/bh_vitalyx'

echo -e "######################################################################################################################"
echo -e "\t\t\t Starting bhcloudservice Deployment for VitalyX Application"
echo -e "######################################################################################################################\n"

if [ ! -f $temp/dist*.zip ]
then
	echo -e "######################################################################################################################"
    echo -e "\t\t\t\t\t No dist*.zip found at/home/bh_vitalyx/file-transfer"
	echo -e "\t\t\t\t\t Skipping Deployment of bhcloudservice Package"
	echo -e "######################################################################################################################\n"
else
	echo -e "######################################################################################################################\n"
	if [ -d "$dir/bh_vitalyx_cloud_service" ]
	then
		echo -e "\t\t\t\t\t 1) Deleting bh_vitalyx_cloud_service Directory\n"
		rm -rf $dir/bh_vitalyx_cloud_service
		mkdir -p $dir/bh_vitalyx_cloud_service
	else
		mkdir -p $dir/bh_vitalyx_cloud_service
		echo -e "\t\t\t\t\t 2) Directory created for bh_vitalyx_cloud_service\n"
	fi

	echo -e "\t\t\t\t\t 3) Moving Python-Package file to $dir/bh_vitalyx_cloud_service/ \n"
	cp -r $temp/dist-*.zip $dir/bh_vitalyx_cloud_service/

	echo -e "\t\t\t\t\t 4) Extracting ZIP file\n"
	echo -e "######################################################################################################################\n"
	unzip $dir/bh_vitalyx_cloud_service/dist-*.zip -d $dir/bh_vitalyx_cloud_service/
	mv $dir/bh_vitalyx_cloud_service/dist*/* $dir/bh_vitalyx_cloud_service/
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 5) Running Database Operations\n"
	mkdir -p $dir/bh_vitalyx_cloud_service/sql 
	mv $dir/bh_vitalyx_cloud_service/schema.sql $dir/bh_vitalyx_cloud_service/sql/
	cd $dir/bh_vitalyx_cloud_service/sql
	sqlite3  cloud_packets.sqlite3 ".read schema.sql"
	table=`sqlite3 cloud_packets.sqlite3 ".tables"`
	if [ "$table" == "data_packet" ]
	then
		echo -e "\t\t\t\t\t     $table found in database\n"
	else
		echo -e "\t\t\t\t\t     No tables found in database\n"
	fi
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 6) Installing bhcloudservice Python Package !!! \n"
	pip3 install $dir/bh_vitalyx_cloud_service/*.whl
	
	if [ "$?" == "0" ]
	then 
		echo -e "######################################################################################################################\n"
		echo -e "\t\t\t\t\t \033[32mbhcloudservice Python Package installation was Successfull \e[0m""\n"
	else 
		echo -e "######################################################################################################################\n"
		echo -e "\t\t\t\t\t \033[31mbhcloudservice Python Package installation Failed \e[0m""\n"
		exit 1
	fi
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 7) Copying system.d files to /etc/ \n"
	sudo cp -r $dir/bh_vitalyx_cloud_service/etc/* /etc/
	echo -e "\t\t\t\t\t 8) Restarting the Daemon Service \n"
	sudo systemctl daemon-reload
	if [ "$?" == "0" ]
	then 
		echo -e "######################################################################################################################\n"
		echo -e "\t\t\t\t\t \033[32mDaemon service restarted Successfully \e[0m""\n"
	else 
		echo -e "######################################################################################################################\n"
		echo -e "\t\t\t\t\t \033[31mError While restarting the Daemon Service\e[0m""\n"
		exit 1
	fi
	echo -e "######################################################################################################################\n"
	echo -e "\t\t\t\t\t 9) Restarting bh_vitalyx_cloud service\n"
	sudo systemctl enable bh_vitalyx_cloud
	sudo systemctl start bh_vitalyx_cloud
	if [ "$?" == "0" ]
	then
		echo -e "\t\t\t\t\t \033[32mbh_vitalyx_cloud service restarted Successfully \e[0m""\n"
		mv $temp/dist-*.zip $dir/archive/
		rm -rf $temp/dist-*.zip
	else 
		echo -e "\t\t\t\t\t \033[31mError While restarting the bh_vitalyx_cloud Service\e[0m""\n"
		exit 1
	fi
	echo -e "######################################################################################################################\n"
fi