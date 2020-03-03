def node = 'Slave-VitalyX-G4CE9430FSQE'
def URL_download = 'http://10.177.104.197:8888/VitalyX-MOXA-Service/Python-Packages/'
def build_save_location = 'D:\\VitalyX-Project-files\\VitalyX-MOXA-Service\\Builds\\'
def package_save_location = 'D:\\VitalyX-Project-files\\VitalyX-MOXA-Service\\Python-Packages\\'
def BUILD_STATUS = 'SUCCESS'
def credentialsId = '502744313'
def git_url = 'git@github.build.ge.com:VitalyX/vitalyx-moxa-service.git'
def to_list = 'VitalyX_MTC@ge.com,Christopher.Grover@bhge.com,Arif.M.Shaikh@bhge.com'
def message = '\n'
def daysToKeepBuild = '60'
def numToKeepBuild = '50'
def tokentostart = 'VitalyX@Moxa01'


pipeline {

  agent {label "${node}"}

  triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'ref', value: '$.ref']],
     causeString: 'Triggered on $ref',
     token: "${tokentostart}",
     printContributedVariables: false,
     printPostContent: false,
     silentResponse: false,
     regexpFilterText: '$ref',
     regexpFilterExpression: 'refs/heads/bhcloudservice-pypi'
    )
  }

  stages {
        stage('Prechecks'){
            steps{
                script{
                    try{
                        cleanWs notFailBuild: true
                        echo "Prechecks are completed !!!"
                    }
                    catch (Exception e){
                        echo "Error while cleaning Workspace !!!"
                    }}}}
        stage('Git Checkout') {
            steps {
                script {
                    echo 'Git checkout started !!!'
                    checkout([$class: 'GitSCM', branches: [[name: '*/bhcloudservice-pypi']], 
                    doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], 
                    userRemoteConfigs: [[credentialsId: "${credentialsId}", 
                    url: "${git_url}"]]])
                    properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', 
                    artifactNumToKeepStr: '', daysToKeepStr: '50', numToKeepStr: '60'))])
                    echo 'Git Checkout Successfull !!!'
                    message = "${message} Git Checkout Successfull !!!\n"                    
				}}}

        stage('Generate Python Package'){
            steps{
                script{
                    try{
                        bat "C:\\Python\\python.exe setup.py bdist_wheel"
                        echo "Python Package created successfully !!!"
                        message = "Python Package created successfully !!!\n"
                    }
                    catch (Exception e){
                        echo "Error while buiding python package !!!"
                        message = "Error while buiding python package !!! \n"
                    }}}}
        stage('Zip file'){
            steps{
                script{
                    fileOperations([folderCreateOperation('dist/certificates'), folderCreateOperation('dist/config_files'), folderCreateOperation('dist/etc')])
                    fileOperations([folderCopyOperation(destinationFolderPath: 'dist/certificates', sourceFolderPath: 'bhcloudservice/certificates'), 
                    folderCopyOperation(destinationFolderPath: 'dist/etc', sourceFolderPath: 'bhcloudservice/etc'), 
                    folderCopyOperation(destinationFolderPath: 'dist/config_files', sourceFolderPath: 'bhcloudservice/bh_client/config_files')])
                    fileOperations([fileCopyOperation(excludes: '', flattenFiles: true, includes: 'bhcloudservice/sql/*.sql', targetLocation: 'dist/'), 
                    fileCopyOperation(excludes: '', flattenFiles: true, includes: 'service.py', targetLocation: 'dist/'), 
                    fileCopyOperation(excludes: '', flattenFiles: true, includes: 'datahub-deployment.sh', targetLocation: 'dist/'),
                    fileCopyOperation(excludes: '', flattenFiles: true, includes: 'bhcloudservice/config.json', targetLocation: 'dist/')])
                    fileOperations([fileRenameOperation(destination: "dist-${BUILD_NUMBER}", source: "dist")])
                    fileOperations([fileZipOperation("dist-${BUILD_NUMBER}")])
                    fileOperations([fileCopyOperation(excludes: '', flattenFiles: false, includes: "dist-${BUILD_NUMBER}.zip", targetLocation: "${package_save_location}")])
                    echo "You can download the files from URL ${URL_download}dist-${BUILD_NUMBER}.zip"
                    message = "You can download the files from URL ${URL_download}dist-${BUILD_NUMBER}.zip"
                }}}}
                
        post  {
            always { echo "This build run correctly in Sequence" }
            success { echo "This build ran successfully" 
                emailext (
                        subject: "${BUILD_STATUS} : Job ${env.JOB_BASE_NAME} - Build # ${env.BUILD_NUMBER} ",
                        body: """Status of ${env.JOB_BASE_NAME} BUILD # ${env.BUILD_NUMBER} is ${BUILD_STATUS}, 
                        You can check console output at ${env.BUILD_URL}console
                        ${message}""",
                        to: "${to_list}"
                        )
                }
            failure {
                    emailext (
                        subject: "${BUILD_STATUS} : Job ${env.JOB_BASE_NAME} - Build # ${env.BUILD_NUMBER} ",
                        body: """Status of ${env.JOB_BASE_NAME} BUILD # ${env.BUILD_NUMBER} is ${BUILD_STATUS}, 
                        You can check console output at ${env.BUILD_URL}console
                        ${message}""",
                        to: "${to_list}"
                        )
                }
            unstable { echo 'This will run only if the run was marked as unstable' }
            changed {
                    emailext (
                        subject: "${BUILD_STATUS} : Job ${env.JOB_BASE_NAME} - Build # ${env.BUILD_NUMBER} ",
                        body: """Status of ${env.JOB_BASE_NAME} BUILD # ${env.BUILD_NUMBER} is ${BUILD_STATUS}, 
                        You can check console output at ${env.BUILD_URL}console
                        ${message}""",
                        to: "${to_list}"
                        )
                }}     
}       