class Company < ActiveRecord::Base
  include Paperdragon::Model
  processable :logo

  belongs_to :user
  serialize :logo_meta_data
  serialize :content
end # class Company
