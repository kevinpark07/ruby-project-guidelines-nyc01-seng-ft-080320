class UserScenario < ActiveRecord::Base
    belongs_to :user
    belongs_to :scenario

end