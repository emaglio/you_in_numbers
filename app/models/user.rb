class User < ActiveRecord::Base 
  has_many :report
  serialize :content
  serialize :auth_meta_data
end