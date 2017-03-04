class Report < ActiveRecord::Base 
  belongs_to :user
  serialize :content, Array
end