class Project < ActiveRecord::Base
  belongs_to :user
  has_many :services
    has_many :settings
end
