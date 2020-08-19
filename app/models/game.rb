require 'pry'
require 'tty-prompt'



class Game < ActiveRecord::Base
    has_one :user

    @@prompt = TTY::Prompt.new

    def start()
        puts "Welcome to Hogwarts! My name is Argus Filch. There have been many curious and dangerous occurences in these halls."
        input = @@prompt.select("Would you like to explore?", %w(Yes No))
        if input == 'No'
            puts "Well, that's no fun! Have a good day."
        elsif input == 'Yes'
            self.new_game
        end
    end
    
    def new_game

        self.new_user

        puts "First, let's get you ready to face the Challenges."

        items = self.choose_items
        spells = self.choose_spells
        self.user.get_ready(items, spells)
        result = @@prompt.select("Would you like to review your selections or continue?", %w(Review Continue))

        # list table of spells/items
        @@prompt.select("Congratulations, it looks like you've chosen wisely. Dumbledore has a mission for you!", %w(Ok!))
    
        start_scenario
    end

    def new_user
        name = @@prompt.ask("What is your name, young wizard?", echo: true)
        user = User.create(name: name)
        user.game = self
        puts "Hi #{self.user.name}! Interesting name. Let's get you set up to explore."
    end

    def choose_items
        items = ["Nimbus 2000", "Invisibility Cloak", "Slightly Dull Sword", "A Six-pack of Butter Beer", "Marauder's Map", "Port Key"]
        item_choices = @@prompt.multi_select("Here are some useful items. Please choose two.", items, min: 2, max: 2)
        item_choices
    end

    def choose_spells
        spells = %w[Alohomora Expelliarmus Accio Lumos Reducto Obliviate]
        spell_choices = @@prompt.multi_select("Would you like to learn some spells?. Here, let me teach two", spells, min: 2, max: 2)
    end



    
    # def list_items
    #     #Better display mechanism?
    #     Item.all.each_with_index do |item, index|
    #         puts "#{index +1}. #{item.name}:    #{item.description}"
    #     end
    # end
    
    # def choose_items
    #     puts "Type the name of the item you wish to receive."
    #     item1 = gets.chomp
    #     self.user.pick_item(Item.find_by(name: item1))
    #     # binding.pry
    #     puts "Great choice! Now choose one more."
    #     item2 = gets.chomp
    #     if self.user.items.include?(item1)
    #         puts "You already have this. Please choose again:"
    #         list_items
    #     else
    #         self.user.pick_item(Item.find_by(name: item2))
    #     end
    # end
    
    # def list_spells
    #     spells = [
    #         Spell.find_by(spell: "Alohomora"),
    #         Spell.find_by(spell: "Expelliarmus"),
    #         Spell.find_by(spell: "Accio"),
    #         Spell.find_by(spell: "Lumos"),
    #         Spell.find_by(spell: "Reducto"),
    #         Spell.find_by(spell: "Obliviate")
    #     ]

    #     spells.each_with_index do |s,i|
    #         #Better display mechanism?
    #         puts "#{i +1}. #{s.spell}:    #{s.effect}"
    #     end
    # end

    # def choose_spells
    #     puts "Type the name of the spell you wish to learn."
    #     spell1 = gets.chomp
    #     self.user.pick_spell(Spell.find_by(spell: spell1))
    #     puts "Great choice! Now choose one more."
    #     spell2 = gets.chomp
    #     if self.user.spells.include?(spell1)
    #         puts "You already know this spell. Please choose again:"
    #         list_spells
    #     else
    #         self.user.pick_spell(Spell.find_by(spell: spell2))
    #     end
    # end

    # def start_scenario
    #     UserScenario.create(user: self.user, scenario: Scenario.create)
    #     # user.scenario.start_scenario
    # end
end
