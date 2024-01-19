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

    }
