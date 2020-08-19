class User < ActiveRecord::Base
    has_many :user_scenarios
    has_many :user_spells
    has_many :user_items
    has_many :scenarios, through: :user_scenarios
    has_many :spells, through: :user_spells
    has_many :items, through: :user_items
    belongs_to :game

    # def pick_item(item)
    #     UserItem.create(user_id: self.id, item_id: item.id)
    # end

    # def pick_spell(spell)
    #     UserSpell.create(user_id: self.id, spell_id: spell.id)
    # end

    # def options
    #     self.items.each_with_index do |item, index|
    #         puts "#{index +1}. #{item.name}: #{item.description}"
    #     end

    #     self.spells.each_with_index do |s,i|
    #         puts "#{i +1}. #{s.spell}: #{s.effect}"
    #     end
    # end

    def spell_names
        self.spells.map {|spell| spell.spell_name}
    end

    def item_names
        self.items.map {|item| item.name}
    end

    def get_ready(items, spells)
        items.each {|item| UserItem.create(user_id: self.id, item_id: Item.find_by_name(item).id)}
        spells.each {|spell| UserSpell.create(user_id: self.id, spell_id: Spell.find_by(spell_name: spell).id)}
    end


end