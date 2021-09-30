## terraform-aws-ansible-sentry-ubuntu

## Requirements:

aws-cli\
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/bin/aws-cli -b /usr/bin
```

git\
Terraform v 1.0.0 or newer\
Vagrant (for testing locally)\
Ansible (install python3 & python3-pip then run "python3 -m pip install --user ansible"\
AWS cloud account with permissions to create a ec2 instance\
boto & boto3 (python3 -m pip install --user boto boto3)

## Prereqs for ansible:
Run\  
```
ssh-keygen -t rsa -f ~/.ssh/ubuntu -C `whoami`   
chmod 400 ~/.ssh/ubuntu
```

## Git clone the project, or extract the zip to your ~ directory 

* git clone the project from the repository: 
     * git clone https://github.com/binbashblog/terraform-AWS-ansible-sentry-ubuntu.git or extract the zip file
	 
## Create the AWS user and obtain the Access Key and Secret Key

* Go to the AWS Console > IAM > Create User.\
    * User name: terraform_iam_user\
    * Tick 'Access key - Programmatic access', click Next: Permissions\
    * Click 'Attach existing policies directly > AdministratorAccess', click Next: Tags\
    * Click 'Next: Review'\
    * Click 'Create user'\
    * Copy the 'Access key ID' & 'Secret access key'\
    * Rename the terraform.tfvars.example file to terraform.tfvars and paste in the access key and secret key


## Prepare the tf environment
* Rename terraform.tfvars.example to terraform.tfvars (if not already done)
    * Amend the variables for your environment if they differ.

## Running terraform
* Run ```terraform init``` to initialize the terraform environment and download modules
    * At this point any errors or warnings in the config will appear, if no warnings then continue to below:

* Run ```terraform plan``` to verify the changes being made and that no errors appear

* Run ```terraform apply``` and wait for it to complete, shortly after ansible will be run.
The IP of the instance will appear.

## To access Sentry via the hostname
* Edit your hosts file as follows:   
```   
<Public IP of the instance>	sentry-vm	sentry-vm.example.org
```   

Now open your browser and enter https://sentry-vm

NOTE: you will get a 404 error from nginx if you don't use the hostname

* The web page will appear, due to the non interactive mode of the Sentry installation, you will need to ssh to the instance using your key pair and external ip and create a new user

## Create a superuser for Sentry
* ssh to the instance using the public ip or the hostname (if the hosts file was set as above)    
```ssh ubuntu@sentry-vm.example.org -i ~/.ssh/ubuntu```

* Run the following to create a new user:

```
cd ~/sentry_install/
docker-compose run --rm web createuser
```   

* You will be prompted for your email address, and prompted to enter a password twice. 
* Then press y to make the user a superuser.
* You can then log into sentry and complete the setup
