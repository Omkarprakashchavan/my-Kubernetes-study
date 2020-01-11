pipeline {
  agent any

  stages {
        stage('Git Checkout') {
            steps {
                script {
                    echo 'Git checkout started !!!'
                    checkout([$class: 'GitSCM', branches: [[name: '*/bhcloudservice-pypi']], 
                    doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], 
                    userRemoteConfigs: [[credentialsId: 'SSH', 
                    url: 'git@github.build.ge.com:VitalyX/vitalyx-moxa-service.git']]])
                    properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', 
                    artifactNumToKeepStr: '', daysToKeepStr: '1', numToKeepStr: '2'))])
                    echo 'Git Checkout Successfull !!!'
                    //message = "${message} Git Checkout Successfull !!!\n"                    
				}}}

        stage('Create Wheel Package for bdist') {
            steps {
                script{
                        bat "python --version"
                        echo "Install wheel if it is not installed already"
                        //bat "C:\\Users\\503162493\\AppData\\Local\\Programs\\Python\\Python37\\Scripts\\pip.exe\\pip install wheel"
				}}}
        stage('Clear old files'){
            steps{
                script{
                    try{
                        deleteDir(build)
                        deleteDir(dist) 
                        //deleteDir(eggs)
                    }
                    catch (Exception e){
                        echo "Error while deleting old files"
                    }
                }
            }
        }
        stage('Generate Python Package'){
            steps{
                script{
                    try{
                        bat "python setup.py bdist_wheel"
                    }
                    catch (Exception e){
                        echo "Error while buiding python package"
                    }
                }
            }
        }
        stage('Zip file'){
            steps{
                script{
                    fileCopyOperation(excludes: '', flattenFiles: false, includes: 'bhcloudservice/certificates', targetLocation: "dist")
                    //fileOperations([fileZipOperation('dist')])
                }
            }
        }
        }}

        