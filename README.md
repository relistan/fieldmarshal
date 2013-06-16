# Here Be Dragons!

This project hasn't been updated in awhile. OpsCode Chef's Knife EC2
tools obsolete most of this functionality.  This is primarily of
interest for posterity at this point.

Thanks to everyone who used it!

# fieldmarshal

### Functionality
Field Marshal is a simple tool to manage EC2 instances for a single
user or across a team.  The main functionality revolves around
shared naming for instances across a team so they can be accessed
by a common name.  

### Installing

In order to run Field Marshal, you need amazon_aws and rightaws
version 1.1.0 installed.

Field Marshal can generate its own configuration file and fire up
your configured system editor by running:

  ec2 config

If you want to have Field Marshal available anywhere on your system
you will want to add it to your system path by running something
like this from inside the Field Marshal directory:

  echo "export PATH=$PATH:`pwd`" >> ~/.profile

### Running
Simply running 'ec2' will list the options available.  E.g.

Usage: ec2 [command]
	Commands:
	  - clone        --> Start a new instance with the same settings as the named instance
	  - config       --> Edit existing or a create new configuration file
	  - create       --> Create a new instance with the first arg as the name
	  - flush        --> Flush the Field Marshal instance cache manually
	  - http         --> Connect to port 80 on the instance in a web browser
	  - list         --> List instances
	  - name         --> Set a name or get the instance ID for a name
	  - scp          --> Copy a file to or from the instance using scp
	  - ssh          --> Connect to the instance over ssh
	  - ssh_config   --> List hosts in an ssh_config friendly format
	  - shutdown     --> Terminate an EC2 instance by name
