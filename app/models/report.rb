class Report < ApplicationRecord
  belongs_to :user
  belongs_to :subject
  serialize :cpet_params
  serialize :cpet_results
  serialize :rmr_params
  serialize :rmr_results
  serialize :content
end
