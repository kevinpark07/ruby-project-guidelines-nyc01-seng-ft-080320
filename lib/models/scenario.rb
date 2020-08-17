class Scenario < ActiveRecord::Base
    has_many :user_scenarios
    has_many :users though: :user_scenarios

end