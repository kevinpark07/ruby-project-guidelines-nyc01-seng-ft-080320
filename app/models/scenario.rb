class Scenario < ActiveRecord::Base
    has_many :user_scenarios
    has_many :users, through: :user_scenarios

end