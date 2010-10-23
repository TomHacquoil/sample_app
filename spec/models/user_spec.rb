require 'spec_helper'

describe User do

  before(:each) do
		@attr = { :name => "Example User", 
							:email => "user@example.com",
							:password => "foobar",
							:password_confirmation => "foobar" }
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should require an email address" do
		no_name_user = User.new(@attr.merge(:email => ""))
		no_name_user.should_not be_valid
	end

	it "should reject names that are too long" do
		long_name = "a" * 41 # Reject names longer than 40 characters
		long_name_user = User.new(@attr.merge(:name => long_name))
		long_name_user.should_not be_valid
	end

	it "should accept valid email addresses" do
		addresses = %w[user@foo.com UNDER_SCORES@foo.bar.org first.last@foo.jp]
		addresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should be_valid
		end
	end

	it "should not accept invalid email addresses" do
		addresses = %w[user@foo,com lol_at_foo.com example.user@foo.]
		addresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should_not be_valid
		end
	end

	it "should not allow duplicate email addresses (case insensitive)" do
		# Put a user with given attributes into the database
		upcased_email = @attr[:email].upcase		
		User.create!(@attr.merge(:email => upcased_email))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid	
	end

	it "should require a password" do
		User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
	end

	it "should require a matching password confirmation" do
		User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
	end

	it "should reject short passwords" do
		short = "a" * 5
		hash = @attr.merge(:password => short, :password_confirmation => short)
		User.new(hash).should_not be_valid
	end

	it "should reject long passwords" do
		long = "a" * 41
		hash = @attr.merge(:password => long, :password_confirmation => long)
		User.new(hash).should_not be_valid
	end

	describe "password encryption" do

		before(:each) do
			@user = User.create!(@attr)
		end
	
		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end	

	end	


end
