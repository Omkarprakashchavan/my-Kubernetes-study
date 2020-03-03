def node = 'Slave-VitalyX-G4CE9430FSQE'
def package_archive_location = 'D:\\VitalyX-Project-files\\authentication-Library\\Archive\\'
def BUILD_STATUS = 'SUCCESS'
def credentialsId = '502744313'
def node_url = 'http://10.177.104.197:8888/authentication-Library/Archive/'
def authentication_library = 'D:\\VitalyX-Project-files\\Project-Files\\VitalyX-Client\\mns-angular-libraries\\dist\\authentication-library\\'
def git_url = 'git@github.build.ge.com:Measurement-and-Sensing-Platform/mns-angular-libraries.git'
//def to_list = 'VitalyX_MTC@ge.com'
def to_list = 'Omkar.chavan@bhge.com'
def proxy = 'http://cis-americas-pitc-cinciz.proxy.corporate.ge.com:80'
def registry = 'https://registry.npmjs.org/'
def message = '\n'
def daysToKeepBuild = '60'
def numToKeepBuild = '50'
def tokentostart = 'VitalyX@authLibrary.tgz'

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
     regexpFilterExpression: 'refs/heads/master'
    )}

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
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], 
                    doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], 
                    userRemoteConfigs: [[credentialsId: "${credentialsId}", 
                    url: "${git_url}"]]])
                    properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', 
                    artifactNumToKeepStr: '', daysToKeepStr: '50', numToKeepStr: '60'))])
                    echo 'Git Checkout Successfull !!!'
                    message = "${message} Git Checkout Successfull !!!\n"                    
				}}}

        stage('NPM install'){
            steps{
                script{
                    try {
                        echo 'Installaing required packages from NPM'
                        bat "npm set proxy ${proxy}"
                        bat "npm set https-proxy ${proxy}"
                        bat "npm set registry ${registry}"
                        bat "npm cache clean --force"
                        bat "npm install --loglevel info"
                        echo 'Installation of required npm packages is completed !!!'
                        message = " ${message} Installation of required npm packages is completed !!!\n"
                    }
                    catch (Exception e) {
                        echo 'NPM Module Installation Failed !!! Please check Internet connectivity'
                        BUILD_STATUS = "FAILED"
                        message = "${message} NPM Module Installation Failed !!! Please check Internet connectivity\n"
                        throw e
                    }}}}
        stage('Build Library'){
            steps{
                script{
                    try {
                        echo 'Build Process been started !!!'
                        bat "node --max_old_space_size=8192 node_modules/@angular/cli/bin/ng build authentication-library --configuration=production"
                        echo 'Build Process been Completed !!!'
                        message = "${message} Build Process been Completed !!!\n"
                    }
                    catch (Exception e) {
                        echo 'Error While Building the code, Please check the Code/Syntax !!!'
                        BUILD_STATUS = "FAILED"
                        message = "${message} Error While building the code, Please check the Code/Syntax !!!\n"
                        throw e
                        }
                }}}
        stage('Pack Library'){
            steps{
                script{
                    try {
                        echo 'Creating Package for the Library'
                        bat "npm pack dist\\authentication-library\\"
                        echo 'Authentication Library Package created Successfully !!!'
                        message = " ${message} Authentication Library Package created Successfully !!!\n"
                        archiveArtifacts artifacts: 'authentication-library-0.0.1.tgz', onlyIfSuccessful: true
                    }
                    catch (Exception e) {
                        echo 'Error while creating Authentication Library Package'
                        BUILD_STATUS = "FAILED"
                        message = "${message} Error while creating Authentication Library Package\n"
                        throw e
                    }}}}
        stage('Archive'){
            steps{
                script{
                    try {
                        bat "${authentication_library}authentication-library-0.*"
                    }
                    catch (Exception e) {
                        echo 'Error while deleting old the authentication-library'
                        message = "${message} Error while deleting old the authentication-library\n"
                        BUILD_STATUS = "SUCCESS"
                    }
                    try {
                        fileOperations([fileCopyOperation(excludes: '', flattenFiles: false, includes: 'authentication-library-0.0.1.tgz', 
                        targetLocation: "${package_archive_location}")])
                        fileOperations([fileCopyOperation(excludes: '', flattenFiles: false, includes: 'authentication-library-0.0.1.tgz', 
                        targetLocation: "${authentication_library}")])
                    }
                    catch (Exception e) {
                        echo 'Error while Copying the authentication-library'
                        message = "${message} Error while Copying authentication-library*.tgz\n"
                        BUILD_STATUS = "SUCCESS"
                    }
                    try {
                        fileOperations([fileRenameOperation(destination: "${package_archive_location}authentication-library-0.0.1-Build#${BUILD_NUMBER}.tgz", 
                        source: "${package_archive_location}authentication-library-0.0.1.tgz")])
                    } 
                    catch (Exception e) {
                        echo "Error while renaming the authentication-library"
                        message = "${message} Error while Copying the authentication-library\n"
                        BUILD_STATUS = "FAILED"
                        throw e
                    }}}}}
                
        post  {
            always { echo "This build run correctly in Sequence" }
            success { echo "This build ran successfully"  }
            failure {
                    emailext (
                        subject: "${BUILD_STATUS} : Job ${env.JOB_BASE_NAME} - Build # ${env.BUILD_NUMBER} ",
                        body: """Status of ${env.JOB_BASE_NAME} BUILD # ${env.BUILD_NUMBER} is ${BUILD_STATUS}, 
                        ${message} You can access console log of Build on : ${env.BUILD_URL}console\n
                        You can access the Old authentication Libraries from URL: ${node_url}""",
                        to: "${to_list}"
                        )
                }
            unstable { echo 'This will run only if the run was marked as unstable' }
            changed {
                    emailext (
                        subject: "${BUILD_STATUS} : Job ${env.JOB_BASE_NAME} - Build # ${env.BUILD_NUMBER} ",
                        body: """Status of ${env.JOB_BASE_NAME} BUILD # ${env.BUILD_NUMBER} is ${BUILD_STATUS}, 
                        ${message} You can access console log of Build on : ${env.BUILD_URL}console\n
                        You can access the Old authentication Libraries from URL: ${node_url}""",
                        to: "${to_list}"
                        )}}}  