# == Schema Information
# Schema version: 20101018143310
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, 			:presence => true,
												:length => { :maximum => 40 }
	validates :email, 		:presence => true,
												:format => { :with => email_regex },
												:uniqueness => { :case_sensitive => false }

	# Automatically create the virtual attribute 'password_confirmation'
	validates :password,	:presence => true,
												:confirmation => true,
												:length => { :within => 6..40 }  	


end
