class User < ActiveRecord::Base
    has_many :user_scenarios
    has_many :user_spells
    has_many :user_items
    has_many :scenarios, through: :user_scenarios
    has_many :spells, through: :user_spells
    has_many :items, through: :user_items
    belongs_to :game

    def pick_item(item)
        UserItem.create(user_id: self.id, item_id: item.id)
    end

    def pick_spell(spell)
        UserSpell.create(user_id: self.id, spell_id: spell.id)
    end

end