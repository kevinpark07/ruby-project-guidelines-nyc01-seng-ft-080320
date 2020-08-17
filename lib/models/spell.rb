class Spell < ActiveRecord::Base
    has_many :user_spells
    has_many :users though: :user_spells

end
