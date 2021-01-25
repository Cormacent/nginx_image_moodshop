def dockerhub = "zakimaulana/nginxmoodshop"
def image_name = "${dockerhub}:${BRANCH_NAME}"
def builder

pipeline {
    agent any 

    parameters {
        choice(name: 'DEPLOY', choices: ['DEV','PROD'])
    }

    stages {
        stage('build docker image') { 
             steps {
                 script {
                     builder = docker.build(image_name, "--no-cache .")
                 }
            }
        }
        stage('test docker image') { 
             steps {
                 script {
                     builder.inside {
                         sh 'echo passed'
                     }
                 }
            }
        }
        stage('Push Image to Registries') { 
            steps {
                script {
                    builder.push()
                }
            }
        }
        stage("Deploy to other server"){
            parallel {
                stage("DEV"){
                    when {
                        expression {
                            params.DEPLOY == "DEV"
                        }
                    }
                    steps{
                        script {
                            sshPublisher(
                                publishers: [
                                    sshPublisherDesc(
                                        configName: 'development',
                                        verbose: true,
                                        transfers: [
                                            sshTransfer(
                                                sourceFiles: '*',
                                                execCommand: "docker pull ${image_name}; cd /home/developer/app; docker-compose down; docker-compose up -d",
                                                execTimeout: 1200000
                                            )
                                        ]
                                    )
                                ]
                            )
                        }
                    }
                }
                stage("PROD"){
                    when {
                        expression {
                            params.DEPLOY == "PROD"
                        }
                    }
                    steps{
                        script {
                            sshPublisher(
                                publishers: [
                                    sshPublisherDesc(
                                        configName: 'production',
                                        verbose: true,
                                        transfers: [
                                            sshTransfer(
                                                sourceFiles: '*',
                                                execCommand: "docker pull ${image_name}; cd /home/production/app; docker-compose down; docker-compose up -d",
                                                execTimeout: 1200000
                                            )
                                        ]
                                    )
                                ]
                            )
                        }
                    }
                }
            }
        }
    }
}
