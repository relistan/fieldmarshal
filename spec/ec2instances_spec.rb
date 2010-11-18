load File.expand_path(File.join(File.dirname(__FILE__), '..', 'ec2'))
require 'yaml'

describe EC2Instances do

	before :all do
		@fake_entries = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "info"))
		$config = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "ec2rc"))
		sdb_query = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "sdb_query"))
		@all_instances = EC2Instances.new
		@all_instances.sdb.stub!(:get_attributes).and_return(@fake_entries['i-19028f70'])
		@all_instances.sdb.stub!(:get_all).and_return(sdb_query)
		@all_instances.flush # No caching!
		@all_instances.stub!(:info).and_return(@fake_entries)
	end

	after :all do
		@all_instances.flush # Make sure we don't cache test data
	end
	
	it "should have all_instances defined" do
		@all_instances.should be_an_instance_of(EC2Instances)
	end

	it "should be able to connect to the EC2 API" do
		@all_instances.ec2.should be_an_instance_of(RightAws::Ec2)
	end

	it "should have information about EC2 instances" do
		@all_instances.info.keys.should have(4).items
	end

	it "should return individual instance information" do
		@all_instances.get_instance("i-19028f70").class.should be(EC2Instance)
	end

	it "should return the AWS id for a custom name" do
		@all_instances.id_for_name("blog").should == 'i-19028f70'
	end

	it "should return a hash for mapping ids to names" do
		@all_instances.ids_to_names.should have(1).items
	end

	it "should map hostnames to ips" do
		ip = @all_instances.get_instance("i-19028f70").dns_name
		@all_instances.hostname_to_ip(ip).should == '14.43.96.210'
	end

end
