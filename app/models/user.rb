class User < ActiveRecord::Base
    has_many :user_scenarios
    has_many :user_spells
    has_many :user_items
    has_many :scenarios, through: :user_scenarios
    has_many :spells, through: :user_spells
    has_many :items, through: :user_items

    
end