load 'ec2'

describe EC2Instances do
	
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
