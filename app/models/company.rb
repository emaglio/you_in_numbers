class Company < ActiveRecord::Base
  belongs_to :user
  serialize :logo_meta_data
  serialize :content
end # class Company
