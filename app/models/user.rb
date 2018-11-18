class User < ApplicationRecord
  has_many :report
  has_one :company
  serialize :content
  serialize :auth_meta_data
end
