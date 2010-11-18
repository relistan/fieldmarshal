load File.expand_path(File.join(File.dirname(__FILE__), '..', 'ec2'))
require 'yaml'
require 'mocks'

describe EC2Instances do

	before :all do
		@fake_entries = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "info"))
		$config = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "ec2rc"))
		sdb_query = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "sdb_query"))
		$all_instances = EC2Instances.new
		$all_instances.sdb.stub!(:get_attributes).and_return(@fake_entries['i-19028f70'])
		$all_instances.sdb.stub!(:get_all).and_return(sdb_query)
		$all_instances.flush # No caching!
		$all_instances.stub!(:info).and_return(@fake_entries)
		@instance = EC2Instance.new(@fake_entries['i-19028f70'])
	end

	after :all do
		$all_instances.flush # Make sure we don't cache test data
	end
	
	it "should return the user name" do
		@instance.username.should == "ubuntu"
	end

	it "should return the correct aws instance id" do
		@instance.aws_id.should == "i-19028f70"
	end

	it "should return the common name for the instance" do
		@instance.name.should == "blog"
	end

	it "should try to ssh to the host" do
		@instance.stub!(:key).and_return("somekey.pem")
		@instance.ssh(['ls'])
		$io.string.should == "ssh -i somekey.pem ubuntu@ec2-14-43-96-210.compute-1.amazonaws.com \n"
	end
end
