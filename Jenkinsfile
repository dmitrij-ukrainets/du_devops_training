#!groovy
node{
    stage('cloneFromGit'){
        git branch: 'task3', credentialsId: '216a1e77-18d2-424b-91c5-956eb92ea61e', url: 'https://github.com/dmitrij-ukrainets/du_devops_training.git'
    }
    stage('buildNewWarVersion'){
        sh('chmod +x gradlew && ./gradlew setBuildVersion && ./gradlew build')
    }
    def propertiesFile = readFile 'gradle.properties'
	def version = propertiesFile.substring(8)
    stage('pushToGit'){
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '216a1e77-18d2-424b-91c5-956eb92ea61e', usernameVariable: 'GUNAME', passwordVariable: 'GPASS']]) {
            sh('git config --global user.name "dmitrij-ukrainets"')
            sh('git config --global user.email dmitrij_ukrainets@epam.com')
            sh("git commit -am \"Jenkins auto commit. Build - ${version}\"")
            sh('git push https://${GUNAME}:${GPASS}@github.com/dmitrij-ukrainets/du_devops_training.git task3')
        }
    }
    stage('copyToNexus'){
        withCredentials([usernamePassword(credentialsId: '3b38b037-4471-46c2-9f46-6ee28a7e1ae9', passwordVariable: 'NPASS', usernameVariable: 'NUNAME')]) {
            dir('build/libs'){
                sh "curl -v -u $NUNAME:$NPASS --upload-file task3.war \"http://192.168.0.10:8081/repository/training/task3/${version}/task3.war\""
					def VERS = '${version}'
            }
        }    
    }
    stage('deployToTomcat01'){
        withCredentials([usernamePassword(credentialsId: '193216db-fc41-494d-bc50-e627c3e12079', passwordVariable: 'TPASS', usernameVariable: 'TUNAME')]) {
            httpRequest httpMode: 'POST', url: 'http://192.168.0.10/jk-status?cmd=update&from=list&w=loadbalancer&sw=tomcat01&vwa=1'
            sh "curl \"http://192.168.0.10:8081/repository/training/task3/${version}/task3.war\" | curl -T - -u $TUNAME:$TPASS \"http://192.168.0.11:8080/manager/text/deploy?path=/task3&update=true\" && curl -vv -u $TUNAME:$TPASS \"http://192.168.0.11:8080/manager/text/reload?path=/task3\""
            sleep 60
		}
			def tomcat01Respose = httpRequest "http://192.168.0.11:8080/task3/"
			if (tomcat01Respose.content.contains(version)){
            httpRequest httpMode: 'POST', url: 'http://192.168.0.10/jk-status?cmd=update&from=list&w=loadbalancer&sw=tomcat01&vwa=0'
        }
			else {
				error("Deploy failed - tomcat01")
		}
    }
    stage('deployToTomcat02'){
        withCredentials([usernamePassword(credentialsId: '193216db-fc41-494d-bc50-e627c3e12079', passwordVariable: 'TPASS', usernameVariable: 'TUNAME')]) {
            httpRequest httpMode: 'POST', url: 'http://192.168.0.10/jk-status?cmd=update&from=list&w=loadbalancer&sw=tomcat02&vwa=1'
            sh "curl \"http://192.168.0.10:8081/repository/training/task3/${version}/task3.war\" | curl -T - -u $TUNAME:$TPASS \"http://192.168.0.12:8080/manager/text/deploy?path=/task3&update=true\" && curl -vv -u $TUNAME:$TPASS \"http://192.168.0.12:8080/manager/text/reload?path=/task3\""
            sleep 60
		}
			def tomcat02Respose = httpRequest "http://192.168.0.12:8080/task3/"
			if (tomcat02Respose.content.contains(version)){
            httpRequest httpMode: 'POST', url: 'http://192.168.0.10/jk-status?cmd=update&from=list&w=loadbalancer&sw=tomcat02&vwa=0'    
        }
			else{
			error("Deploy failed - tomcat02")	
		}
    }
}