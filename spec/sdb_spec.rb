load 'ec2'

describe SDB do

	before :each do
		@sdb = SDB.new
		@name = 'test_entry'
		@attributes = { :name => 'test', :value => 'testing 123 123' }
	end

	it "should connect to Amazon Simple DB" do
		@sdb.should_not be_nil
	end

	it "should set attributes to Amazon Simple DB" do
		@sdb.put_attributes @name, @attributes
	end

	it "should get attributes from Amazon Simple DB" do
		@sdb.put_attributes @name, @attributes
		sleep 0.2 # non-deterministic, otherwise -- SDB is not atomic, it seems
		@sdb.get_attributes(@name).should have_key('name')
	end

	it "should retrieve all entries" do
		@sdb.put_attributes @name, @attributes
		@sdb.get_all.size.should have_at_least(1).items
	end

	it "should delete attributes" do
		@sdb.delete_attributes @name
		sleep 0.5 # non-deterministic, otherwise -- SDB is not atomic, it seems
		@sdb.get_attributes(@name).keys.should have(0).items
	end

end
