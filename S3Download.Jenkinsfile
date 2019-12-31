def files = ''
pipeline {
agent any
stages {
    stage('Download') {
      steps {
    withAWS(credentials:'AWS-CRED',region:'us-west-2') {
        //s3Download bucket: 'lumen-image-export', file: "*", force: true, path: 'Dashboard-Builds/Pending/', pathStyleAccessEnabled: true
        //s3Download(file:'targetFolder', bucket:'lumen-image-export', path:'Dashboard-Builds/Pending', force:true)
        //s3FindFiles(bucket:'lumen-image-export', path:'Dashboard-Builds/Pending/', glob:'*.txt')
        sh 'aws s3 cp s3://lumen-image-export/Dashboard-Builds/Pending/ . --recursive --exclude "*" --include "*.txt"'
        }
        
    }}
}}