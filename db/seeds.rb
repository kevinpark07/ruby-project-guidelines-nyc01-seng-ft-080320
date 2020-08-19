require_relative '../config/environment'

require 'pry'

User.destroy_all
Item.destroy_all
Spell.destroy_all
Scenario.destroy_all
UserItem.destroy_all
UserSpell.destroy_all
Character.destroy_all

anson = User.create(name: "Anson")
kevin = User.create(name: "Kevin")

Item.create(name: "Nimbus 2000", description: "Fastest broom on the market")
Item.create(name: "Invisibility Cloak", description: "Hide from your enemies!")
Item.create(name: "Slightly Dull Sword", description: "Stick 'em with the pointy end.")
Item.create(name: "Butter Beer", description: "You never know when you need to feel joy.")
Item.create(name: "Marauder's Map", description: "Helpful Guide to Hogwarts.")
Item.create(name: "Port Key", description: "Returns you to the Hidden Passage")


spells = GetSpell.new.get_spells

spells.each do |s|
    #binding.pry
    spell_name = s["spell"]
    effect_name = s["effect"]
    Spell.create(spell: spell_name, effect: effect_name)
end


characters = GetCharacter.new.get_characters

characters.each do |c|
    data = {
        "name" => c["name"],
        "house" => c["house"],
        "bloodStatus" => c["bloodStatus"],
        "deathEater" => c["deathEater"],
        "dumbledoresArmy" => c["dumbledoresArmy"],
        "orderOfThePhoenix" => c["orderOfThePhoenix"],
        "ministryOfMagic" => c["ministryOfMagic"]
    }
    Character.create(data)
end