pipeline {
agent any
stages {
    stage('Upload') {
      steps {
    withAWS(credentials:'AWS-CRED',region:'us-west-2') {
        //s3Download(file: 'pom.xml', bucket: 's3-artifact-demo-omkar', path: 'test/pom.xml')
        writeFile file: "file.txt-${BUILD_NUMBER}", text: 'Working with files the Groovy way is easy.'
        s3Upload(file:"file.txt-${BUILD_NUMBER}", bucket:'lumen-image-export', path:"Dashboard-Builds/Pending/file-${BUILD_NUMBER}.txt")
      }
    }
    }
}
}