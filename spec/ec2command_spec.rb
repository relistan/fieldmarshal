load File.expand_path(File.join(File.dirname(__FILE__), '..', 'ec2'))
require 'yaml'
require 'stringio'
require 'mocks'

describe EC2Command do

	before :all do
		@fake_entries = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "info"))
		$config = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "ec2rc"))
		sdb_query = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "sdb_query"))
		$all_instances = EC2Instances.new
		$all_instances.sdb.stub!(:get_attributes).and_return(@fake_entries['i-19028f70'])
		$all_instances.sdb.stub!(:get_all).and_return(sdb_query)
		$all_instances.stub!(:info).and_return(@fake_entries)
		$all_instances.stub!(:get_instance).and_return(@fake_entries['i-19028f70'])
		$all_instances.flush # No caching!
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
		$io.string.should include('blog')
	end

	it "should connect over ssh" do
		File.should_receive(:exist?).with("/tmp/ubuntu-images").and_return(true)
		@command.ssh(["blog"])
		$io.string.should == "ssh -i /tmp/ubuntu-images ubuntu@ec2-14-43-96-210.compute-1.amazonaws.com \n"
	end

	it "should copy files over scp" do
		File.should_receive(:exist?).with("/tmp/ubuntu-images").and_return(true)
		@command.scp(["somefile", "ubuntu@blog:sadf"])
		$io.string.should_not include("blog")
	end

	it "should launch a web browser" do
		@command.http(["blog"])
		$io.string.should include("http://#{@fake_entries['i-19028f70'].dns_name}")
	end

	it "should generate its own config file and start an editor" do
		ENV['EDITOR'] = 'vim'
		@command.config([])
		$io.string.should include("vim")
	end

end
