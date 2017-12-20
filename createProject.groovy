import jenkins.model.*
import hudson.model.*
import hudson.model.FreeStyleProject
import hudson.tasks.Shell

//Get instance of Jenkins
def parent = Jenkins.getInstance()

//Define a job name
def jobName = "FirstProject"

//Instantiate a new project
def project = new FreeStyleProject(parent, jobName);

//Set a description for the project
project.setDescription("Test project")

//create shell script
project.buildersList.add(new Shell(
'''\
/var/apache-jmeter-3.3/bin/jmeter.sh -n -t /mnt/tests/tests.jmx -Jenv=staging -Jthread=1 -Jrampup=1 -Jloop=1 -l /mnt/reports/report.jtl -j /mnt/reports/report.csv
'''))

project.save()
parent.reload()