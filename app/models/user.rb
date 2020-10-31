class User < ApplicationRecord
  has_many :subjects
  has_many :reports
  has_one :company
  serialize :content
  serialize :auth_meta_data
end
