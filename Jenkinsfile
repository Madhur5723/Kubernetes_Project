pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/Madhur5723/Kubernetes_Project.git'
            }
        }

        stage('Sending DockerFile to Ansible Server over SSH') {
            steps {
                sshagent(['ansible_demo']) {
                    sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/Project/* ubuntu@172.31.0.181:/home/ubuntu'
                }
            }
        }

        stage('Build Docker Image on Ansible Server') {
            steps {
                sshagent(['ansible_demo']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.0.181 "cd /home/ubuntu && sudo docker build -t my_docker_image ."
                    '''
                }
            }
        }

        stage('Docker Image Tagging') {
            steps {
                sshagent(['ansible_demo']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.0.181 "cd /home/ubuntu && sudo docker image tag my_docker_image madhurshinde/my_docker_image:latest"
                    '''
                }
            }
        }

        stage('Push Docker Image To Docker-Hub') {
            steps {
                sshagent(['ansible_demo']) {
                    withCredentials([string(credentialsId: 'dockerhub_password', variable: 'dockerhub_password')]) {
                        sh '''
                            ssh -o StrictHostKeyChecking=no ubuntu@172.31.0.181 "
                            sudo docker login -u madhurshinde -p ${dockerhub_password} &&
                            sudo docker image push madhurshinde/my_docker_image:latest"
                        '''
                    }
                }
            }
        }

        stage('Copy File From Ansible to Kubernetes Service') {
            steps {
                sshagent(['kubernetes_server']) {
                    sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/Project/* ubuntu@172.31.12.60:/home/ubuntu'
                }
            }
        }

        stage('Kubernetes Deployment using Ansible') {
            steps {
                sshagent(['ansible_demo']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.0.181 "cd /home/ubuntu && ansible-playbook ansible.yml"
                    '''
                }
            }
        }
    }
}
