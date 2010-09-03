# fieldmarshal

### Functionality
Field Marshal is a simple tool to manage EC2 instances for a single
user or across a team.  The main functionality revolves around
shared naming for instances across a team so they can be accessed
by a common name.  

### Installing
A Bundler Gemfile is inclduded so to make sure you have all the gem
dependencies, you simply issue:
  
  bundle install

You can find bundler here: http://gembundler.com/

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
	  - list 	--> List instances
	  - name	--> Set a name or get the instance ID for a name
	  - ssh		--> Connect to the instance over ssh
	  - scp		--> Copy a file to or from the instance using scp
	  - http	--> Connect to port 80 on the instance in a web browser
	  - config	--> Edit existing or a create new configuration file
