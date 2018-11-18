class Subject < ApplicationRecord
  belongs_to :user
  has_many :reports
end # class Subject
