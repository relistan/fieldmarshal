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
		@sdb.get_attributes(@name).should have_key('name')
	end

	it "should retrieve all attributes" do
		@sdb.put_attributes @name, @attributes

		@sdb.get_all.size.should have_at_least(1).items
	end

end
