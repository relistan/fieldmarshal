load 'ec2'
require 'YAML'

describe EC2Instances do

	before :all do
		@fake_entry = YAML.parse("--- !ruby/object:Amazon::SDB::Item \nattributes: !ruby/object:Amazon::SDB::Multimap \n  mset: \n    dns_name: ec2-174-129-203-51.compute-1.amazonaws.com\n    aws_image_id: ami-bb709dd2\n    aws_groups: \n    - default\n    - web-ssh\n    aws_instance_id: i-85c8bdee\n    aws_ramdisk_id: ari-d5709dbc\n    aws_availability_zone: us-east-1c\n    aws_instance_type: m1.small\n    aws_state: running\n    aws_launch_time: \"2010-04-21T23:23:26.000Z\"\n    ssh_key_name: ubuntu-images\n    private_dns_name: domU-12-31-39-07-85-E5.compute-1.internal\n    aws_reservation_id: r-f258489a\n    aws_kernel_id: aki-5f15f636\n    aws_owner: \"372313739446\"\n    aws_reason: \"\"\n    aws_state_code: \"16\"\n    ami_launch_index: \"0\"\n  size: \ndomain: !ruby/object:Amazon::SDB::Domain \n  base: !ruby/object:Amazon::SDB::Base \n    access_key: AKIAJSA2LWGAF66WOWVA\n    secret_key: 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\n    usage: !ruby/object:Amazon::SDB::Usage \n      box_usage: 5.93892e-05\n  name: ec2_names\nkey: chef\n")

	end
	
	it "should have all_instances defined" do
		# $all_instances is defined in the body of the code
		$all_instances.should be_an_instance_of(EC2Instances)
	end

	it "should connect to the EC2 API" do
		$all_instances.ec2.should be_an_instance_of(RightAws::Ec2)
	end

	# Dependent on something existing, but stubbing would defeat the purpose
	it "should have information about EC2 instances" do
		$all_instances.info.keys.size.should have_at_least(1).items
	end

end
