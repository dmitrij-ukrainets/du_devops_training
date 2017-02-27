#!groovy
def grepo = "dmitrij-ukrainets/du_devops_training.git"
def gbranch = "task4"
def rnexus = "192.168.0.10:8081/repository/training"
def sdocker = "192.168.0.10:5000"
def sldocker = "192.168.0.13"
def currenttask = "task4"
def getVersion() {
		def propsString = readFile "gradle.properties"
		def props = new Properties()
		props.load(new StringReader(propsString))
		props.get("version")
		}
def warvers
def docclient_dep(adr,check_warvers){
		def pagecontent = sh(returnStdout: true, script: "curl -s http://${adr}:8080/task4/")
		echo "application version on container: $pagecontent"
		if(pagecontent.contains(check_warvers)){
			echo "Correct version deployed"
		}
		else {
			echo "INCORRECT version deployed"
			currentBuild.result = 'FAILURE'
		}
}
node('master'){
	deleteDir()
	stage('cloneFromGit'){
		git branch: "${gbranch}", credentialsId: 'github', url: "https://github.com/${grepo}"
	}
	stage('buildNewWarVersion'){
		sh('chmod +x gradlew && ./gradlew setBuildVersion && ./gradlew build')
	}
	warvers = getVersion()
	println warvers
	stage('pushToGit'){
		withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'github', usernameVariable: 'GUNAME', passwordVariable: 'GPASS']]) {
			sh('git config --global user.name "dmitrij-ukrainets"')
			sh('git config --global user.email dmitrij_ukrainets@epam.com')
			sh("git commit -am \"Jenkins generated build - ${version}\"")
			sh("git push https://${GUNAME}:${GPASS}@github.com/${grepo} ${gbranch}")
		}
	}
	stage('copyToNexus'){
		withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'NPASS', usernameVariable: 'NUNAME')]) {
			dir('build/libs'){
				sh "curl -v -u $NUNAME:$NPASS --upload-file task4.war \"http://${rnexus}/${currenttask}/${warvers}/task4.war\""
			}
		}
	}
	stage('CreateDockerServer'){
		sh("docker build --build-arg task_version=${warvers} -t ${sdocker}/${currenttask}:${warvers} .")
		sh("docker push ${sdocker}/${currenttask}:${warvers}")

	}
}
node('docclient'){
	stage('run_check'){
		echo "docclient"
		sh("docker run -d --restart=always --name=task4dclient -p 8080:8080 ${sdocker}/${currenttask}:${warvers}")
		sleep 30
		docclient_dep(sldocker,warvers)
		sh("docker stop task4dclient && docker rm task4dclient")
	}
}