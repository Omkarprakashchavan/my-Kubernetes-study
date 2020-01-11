#!/bin/bash
# Maintainer Lumen-Terrain Team
# Developer Omkar.Chavan@bhge.com

# Variable Setting
temp='/tmp/lumen-terrain'
dt=`date +"%d-%m-%Y"`
dir='/var/lumen-terrain'

if [ ! -f $temp/dist*.zip ]
then
    echo " No dist*.zip found at /tmp/lumen-terrain/"
	echo " Skipping Deployment of Front-End build "
else
	echo " Deleting OLD backups of Front-End Build"
	rm -rf $dir/lumen-terrain-dashboard-app_* || echo "no old dist backups available"
	echo " Taking Backup of OLD Front-End build"
	mv lumen-terrain-dashboard-app lumen-terrain-dashboard-app_"$dt" || echo "No lumen-terrain-dashboard-app Directory available"
	echo " Moving DIST.*ZIP files from /tmp/lumen-terrain to /var/lumen-terrain"
	mv $temp/dist*.zip $dir/
	echo " Extracting DIST-*.zip in /var/lumen-terrain "
	unzip $dir/dist*.zip
	echo " Deleting the DIST-*.ZIP files from /var/lumen-terrain "
	rm -rf $dir/dist-*.zip
    build_present="True"
fi

if [ ! -f $temp/build*.zip ]
then
    echo " No build*.zip found at /tmp/lumen-terrain/ "
	echo " Skipping Deployment of Back-End build "
else	
	echo " Deleting OLD backups of Back-End Build "
	rm -rf $dir/build_* || echo "no old Build backups available"
	echo " Taking Backup of OLD Back-End build "
	mv build build_"$dt" || echo "No build Directory available"
	echo " Moving Build.*ZIP files from /tmp/lumen-terrain to /var/lumen-terrain "
	mv $temp/build*.zip $dir/
	echo " Extracting Build-*.zip in /var/lumen-terrain "
	unzip $dir/build*.zip -d build
	echo " Deleting the Build-*.ZIP files from /var/lumen-terrain "
	rm -rf $dir/build-*.zip
	echo " Copy Configuration files from Backup "
	cp -f $dir/build_"$dt"/.env $dir/build/ || echo "No Old .ENV files are found"
	cp -f $dir/build_"$dt"/src/config/config.json $dir/build/src/config/ || echo "No old config.json found"
    build_present="True"
fi

if [ "$build_present" == "True" ]
then
    echo ' Install NPM Packages '
    cd $dir/build
    npm install --production

    echo " Restart Lumen-Terrain Service "
    systemctl stop lumen-terrain
    sleep 2s
    systemctl start lumen-terrain
else
    echo "No build and dist files found at /tmp/lumen-terrain/ for installation !!!"
fi