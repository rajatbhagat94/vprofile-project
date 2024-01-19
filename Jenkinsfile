pipeline {
    agent any
    tools {
	    maven "maven3"
	    jdk "oraclejdk11"
	}
    stages{
        stage('Fetch code') {
          steps{
              git branch: 'main', url:'https://github.com/rajatbhagat94/vprofile-project.git'
          }  
        }

        stage('Build-app') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
        stage('Test'){
            steps {
                sh 'mvn test'
            }

        }

        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool 'sonar4.7'
            }
            steps {
               withSonarQubeEnv('sonar') {
                  sh 'mvn sonar:sonar'
              }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Sending_Notification') {
            steps {
                mail bcc: '', body: 'done with jobs', cc: '', from: '', replyTo: '', subject: 'Testing completed', to: 'rajatpbhagat@gmail.com'
            }
        }
        stage('docker_build_push') {
            environment {
                DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')
             // DOCKER_IMAGE_VERSION = env.BUILD_NUMBER
                DOCKER_IMAGE = "dockerhub1994/app-test:${BUILD_NUMBER}"
            }
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_IMAGE} ."

                    // Login to Dockerhub
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

                    // Push to Dockerhub
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

    }
}
