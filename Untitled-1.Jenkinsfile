pipeline {
agent any
stages {
    stage('S3download') {
      steps {
    withAWS(credentials:'aws-key',region:'ap-south-1') {
        s3Download(file: 'pom.xml', bucket: 's3-artifact-demo-omkar', path: 'test/pom.xml', region: 'ap-south-1')
      }
    }
    }
}
}