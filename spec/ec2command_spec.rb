load File.expand_path(File.join(File.dirname(__FILE__), '..', 'ec2'))
require 'yaml'
require 'mocha'
require 'stringio'
require 'mocks'

describe EC2Command do

	before :all do
		@fake_entries = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "info"))
		$config = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "ec2rc"))
		sdb_query = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "sdb_query"))
		SDB.any_instance.stubs(:get_attributes => @fake_entries['i-19028f70'], 
				:get_all => sdb_query,
				:delete_attributes => nil,
				:put_attributes => nil,
				:sdb_domain => nil)
		$all_instances = EC2Instances.new
		$all_instances.flush # No caching!
		$all_instances.stubs(:info).returns(@fake_entries)
		@command = EC2Command.new
	end

	after :each do
		$io = StringIO.new("")
	end

	after :all do
		$all_instances.flush # Make sure we don't cache test data
	end

	it "should show the id when given the proper name" do
		@command.name(["blog"])
		$io.string.should == "i-19028f70\n"
	end
	
	it "should list all instances" do
		@command.list([])
		EC2Instance.any_instance.stubs(:key).returns("somekey.pem")
		$io.string.should include('blog')
	end

	it "should connect over ssh" do
		$all_instances.stubs(:get_instance).returns(@fake_entries['i-19028f70'])
		EC2Instance.any_instance.stubs(:key).returns("somekey.pem")
		@command.ssh(["blog"])
		$io.string.should == "ssh -i somekey.pem ubuntu@ec2-14-43-96-210.compute-1.amazonaws.com \n"
	end

	it "should copy files over scp" do
		$all_instances.stubs(:get_instance).returns(@fake_entries['i-19028f70'])
		EC2Instance.any_instance.stubs(:key).returns("somekey.pem")
		@command.scp(["somefile", "ubuntu@blog:sadf"])
		$io.string.should_not include("blog")
	end

	it "should launch a web browser" do
		$all_instances.stubs(:get_instance).returns(@fake_entries['i-19028f70'])
		EC2Instance.any_instance.stubs(:key).returns("somekey.pem")
		@command.http(["blog"])
		$io.string.should include("http://#{@fake_entries['i-19028f70'].dns_name}")
	end

	it "should generate its own config file and start an editor" do
		ENV['EDITOR'] = 'vim'
		@command.config([])
		$io.string.should include("vim")
	end


end
