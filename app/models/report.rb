class Report < ActiveRecord::Base 
  belongs_to :user
  serialize :cpet_params
  serialize :cpet_results
  serialize :rmr_params
  serialize :rmr_results
end