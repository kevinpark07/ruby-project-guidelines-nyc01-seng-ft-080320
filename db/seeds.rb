require_relative '../config/environment'

require 'pry'

User.destroy_all
Item.destroy_all
Spell.destroy_all
Scenario.destroy_all

anson = User.create(name: "Anson")
kevin = User.create(name: "Kevin")

wand = Item.create(name: "A Plain Wand", description: "Channels magical energies")
clock = Item.create(name: "Invisibility Clock", description: "Hide from your enemies!")
sword = Item.create(name: "Slightly Dull Sword", description: "Stick 'em with the pointy end.")
beer = Item.create(name: "Butter Beer", description: "You never know when you need to feel joy.")
map = Item.create(name: "Marauder's Map", description: "Helpful Guide to Hogwarts.")
whizbang = Item.create(name: "Whiz-Bangs", description: "Selection of distracting fireworks.")


accio = Spell.create(spell: "Accio-test", effect: "Summon items to your hand.")
protego = Spell.create(spell: "Protego-test", effect: "Creates a limited protective shield around you.")
incendio = Spell.create(spell: "Incendio-test", effect: "Fire can hurt. It can also help.")
stupedy = Spell.create(spell: "Stupefy-test", effect: "Stun an object or being.")


spells = GetSpell.new.get_spells

spells.each do |s|
    #binding.pry
    spell_name = s["spell"]
    effect_name = s["effect"]
    Spell.create(spell: spell_name, effect: effect_name)
end