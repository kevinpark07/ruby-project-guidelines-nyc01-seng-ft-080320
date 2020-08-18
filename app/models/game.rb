require 'pry'
 #testing

class Game < ActiveRecord::Base
    has_one :user

    def start()
        puts "Welcome to Hogwarts! My name is Argus Filch. There have been many curious and dangerous occurences in these halls."
        puts "Would you like to explore? (y/n)"
        input = gets.chomp
        if input == 'n'
            puts "Well, that's no fun! Have a good day."
        elsif input != 'y' && input != 'n'
            puts "I'm sorry, I can't read your handwriting. Please use 'y' or 'n'"
            start()
        elsif input == 'y'
            game()
        end
    end
    
    def game
        puts "What is your name, young one?"
        name = gets.chomp
        user = User.create(name: name)
        user.game = self
        puts "Hi #{self.user.name}! Interesting name. Let's get you set up to explore."
        puts "First, let's get you some items. We're a bit under-resourced, so you can only choose two."
        list_items
        choose_items
        puts "Fantastic #{self.user.name}! Now, we have time to learn two spells. Which would you like to learn?"
        list_spells
        choose_spells
    end
    
    def list_items
        Item.all.each_with_index do |item, index|
            puts "#{index +1}. #{item.name}:    #{item.description}"
        end
    end
    
    def choose_items
        puts "Type the name of the item you wish to receive."
        item1 = gets.chomp
        self.user.pick_item(Item.find_by(name: item1))
        puts "Great choice! Now choose one more."
        item2 = gets.chomp
        self.user.pick_item(Item.find_by(name: item2))
    end
    
    def list_spells
        spells = [
            Spell.find_by(name: "Alohomora"),
            Spell.find_by(name: "Expelliarmus"),
            Spell.find_by(name: "Accio"),
            Spell.find_by(name: "Lumos"),
            Spell.find_by(name: "Reducto"),
            Spell.find_by(name: "Obliviate")
        ]

        spells.each_with_index do |s,i|
            #Better display mechanism?
            puts "#{i +1}. #{s.spell}:    #{s.effect}"
        end
    end

        # Spell.all.each_with_index do |spell, index|
        #     puts "#{index +1}. #{spell.spell}:    #{spell.effect}"
        # end
    
    def choose_spells
        puts "Type the name of the spell you wish to learn."
        spell1 = gets.chomp
        self.user.pick_spell(Spell.find_by(spell: spell1))
        puts "Great choice! Now choose one more."
        spell2 = gets.chomp
        self.user.pick_spell(Spell.find_by(spell: spell2))
    end
    

end
