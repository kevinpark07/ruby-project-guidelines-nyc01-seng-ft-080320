require 'pry'
require 'tty-prompt'



class Game < ActiveRecord::Base
    has_one :user

    @@prompt = TTY::Prompt.new

    def start()
        system("clear")
        puts "Welcome to Hogwarts! My name is Argus Filch. There have been many curious and dangerous occurences in these halls."
        input = @@prompt.select("Would you like to explore?", %w(Yes No))
        if input == 'No'
            puts "Well, that's no fun! Have a good day."
        elsif input == 'Yes'
            self.new_game
        end
    end
    
    def new_game
        system("clear")
        self.new_user
        puts "First, let's get you ready to face the Challenges."
        items = self.choose_items
        spells = self.choose_spells
        self.user.get_ready(items, spells)
        result = @@prompt.select("Would you like to review your selections or continue?", %w(Review Continue))

        # list table of spells/items
        @@prompt.select("Congratulations, it looks like you've chosen wisely. Dumbledore has a mission for you!", %w(Ok!))
        #choose scenario
    
        #start_scenario
    end

    def new_user
        system("clear")
        name = @@prompt.ask("What is your name, young wizard?", echo: true)
        user = User.create(name: name)
        user.game = self
        puts "Hi #{self.user.name}! Interesting name. Let's get you set up to explore."
    end

    def choose_items
        system("clear")
        items = ["Nimbus 2000", "Invisibility Cloak", "Slightly Dull Sword", "A Six-pack of Butter Beer", "Marauder's Map", "Port Key"]
        item_choices = @@prompt.multi_select("Here are some useful items. Please choose two.", items, min: 2, max: 2)
        item_choices.count < 2 ? choose_items : item_choices
    end

    def choose_spells
        system("clear")
        spells = %w[Alohomora Expelliarmus Accio Lumos Reducto Obliviate]
        spell_choices = @@prompt.multi_select("Would you like to learn some spells?. Here, let me teach two", spells, min: 2, max: 2)
        spell_choices.count < 2 ? choose_spells : item_
    end

    def choose_scenario
        system("clear")
        scenarios = ["Join the Death Eaters!", "Fight the Death Eaters!", "Find the Sorceror's Stone"]
        scenario_choice = @@prompt.select(scenarios)
    end

    def start_scenario

    end
end
