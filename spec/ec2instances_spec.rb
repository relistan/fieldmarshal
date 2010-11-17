load File.expand_path(File.join(File.dirname(__FILE__), '..', 'ec2'))
require 'YAML'
require 'mocha'

describe EC2Instances do

	before :all do
		@fake_entries = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "info"))
		$config = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "ec2rc"))
		sdb_query = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures", "sdb_query"))
		SDB.any_instance.stubs(:get_attributes => @fake_entries['i-a10d81ca'], 
				:get_all => sdb_query,
				:delete_attributes => nil,
				:put_attributes => nil,
				:sdb_domain => nil)
		@all_instances = EC2Instances.new
		@all_instances.flush # No caching!
		@all_instances.stubs(:info).returns(@fake_entries)
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
		@all_instances.get_instance("i-27f2294c").class.should be(EC2Instance)
	end

	it "should return the AWS id for a custom name" do
		@all_instances.id_for_name("blog").should == 'i-a10d81ca'
	end

	it "should return a hash for mapping ids to names" do
		@all_instances.ids_to_names.should have(1).items
	end

	it "should map hostnames to ips" do
		instance = @all_instances.get_instance("i-27f2294c")['dns_name']
		@all_instances.hostname_to_ip(instance).should == '174.129.202.215'
	end

end
