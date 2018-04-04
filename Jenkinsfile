node {
 
    // Mark the code checkout 'Checkout'....
    stage ('Build Infrastructure') {
 
		git url: 'https://github.com/yogendra8singh/PB-Infra.git'
			
		// Get the Terraform tool.
		def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
		env.PATH = "${tfHome}:${env.PATH}"
		wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
	 
			// Mark the code build 'plan'....
			stage name: 'Plan', concurrency: 1
			// Output Terraform version
			sh "terraform --version"
					
			//Remove the terraform state file so we always start from a clean state
			//if (fileExists(".terraform/terraform.tfstate")) {
			  //  sh "rm -rf .terraform/terraform.tfstate"
			//}
			//if (fileExists("status")) {
			//    sh "rm status"
			//}
				
			sh "terraform init"
			sh "terraform get"
			sh "set +e;. /etc/profile.d/aws.sh; terraform plan -out=plan.out -detailed-exitcode; echo \$? > status"
			def exitCode = readFile('status').trim()
			def apply = false
			def setup_swarm = false
			def swarm_rolling_update = false
			echo "Terraform Plan Exit Code: ${exitCode}"
			if (exitCode == "0") {
				currentBuild.result = 'SUCCESS'
			}
			if (exitCode == "1") {
				slackSend channel: '#ci', color: '#0080ff', message: "Plan Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
				currentBuild.result = 'FAILURE'
			}
			if (exitCode == "2") {
				stash name: "plan", includes: "plan.out"
				slackSend channel: '#ci', color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
				try {
					input message: 'Apply Plan?', ok: 'Apply'
					apply = true
				} catch (err) {
					slackSend channel: '#ci', color: 'warning', message: "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
					apply = false
					try {
					input message: 'Upgrade new release?', ok: 'Upgrade'
					swarm_rolling_update = true
					} catch (UpdateErr) {
					    swarm_rolling_update = false
					    currentBuild.result = 'UNSTABLE'
					}
				}
			}
		 
			if (apply) {
				stage name: 'Apply', concurrency: 1
				unstash 'plan'
				if (fileExists("status.apply")) {
					sh "rm status.apply"
				}
				sh 'set +e; . /etc/profile.d/aws.sh; terraform apply plan.out; echo \$? > status.apply'
				def applyExitCode = readFile('status.apply').trim()
				if (applyExitCode == "0") {
					slackSend channel: '#ci', color: 'good', message: "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
					setup_swarm = true
				} else {
					slackSend channel: '#ci', color: 'danger', message: "Apply Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
					setup_swarm = false
					currentBuild.result = 'FAILURE'
				}
			}
			
			if (setup_swarm){
				stage name: 'Configure Docker Swarm', concurrency: 1
				// Output Ansible-playbook version
				sh "ansible-playbook --version"
				
				// Run Ansible play book			
				sh "set +e;ansible-playbook -i hosts playbook.yml; echo \$? > setupSwarmStatus"
			
				def setupSwarmExitCode = readFile('setupSwarmStatus').trim()
				echo "Ansible Exit Code: ${setupSwarmExitCode}"
				
				if (setupSwarmExitCode == "0") {
					currentBuild.result = 'SUCCESS'
				}else{
					slackSend channel: '#ci', color: '#0080ff', message: "Ansible Playbook Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
					currentBuild.result = 'FAILURE'
				}
			}
			
			
			if (swarm_rolling_update){
				stage name: 'Docker Swarm Rolling Update', concurrency: 1
				// Output Ansible-playbook version
				sh "ansible-playbook --version"
				
				// Run Ansible play book			
				sh "set +e;ansible-playbook -i hosts update_swarm_cluster.yml --extra-vars 'release=${params.ReleaseVersion}'; echo \$? > swarmRollingUpdateStatus"
			
				def swarmRollingUpdateExitCode = readFile('swarmRollingUpdateStatus').trim()
				echo "Ansible Exit Code: ${swarmRollingUpdateExitCode}"
				
				if (swarmRollingUpdateExitCode == "0") {
					currentBuild.result = 'SUCCESS'
				}else{
					slackSend channel: '#ci', color: '#0080ff', message: "Docker Swarm Rolling update failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
					currentBuild.result = 'FAILURE'
				}
			}
			
		 }
	}

}
