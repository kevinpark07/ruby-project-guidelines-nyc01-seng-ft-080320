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
        puts "Thanks for the information! Now let's get you ready to face the Challenges."
        items = self.choose_items
        spells = self.choose_spells
        self.user.get_ready(items, spells)
        result = @@prompt.select("Would you like to review your selections or continue?", %w(Review Continue))
        # list table of spells/items
        @@prompt.select("Congratulations, it looks like you've chosen wisely. Time to choose your objective!", %w(Ok!))
        choice = choose_scenario
        start_scenario(choice)
    end

    def new_user
        system("clear")
        name = @@prompt.ask("What is your name, young wizard?", echo: true)
        user = User.create(name: name)
        user.game = self
        puts "Hi #{self.user.name}! Interesting name. A few more questions..."
        bloods = %w[pure-blood half-blood muggle unkown]
        blood = @@prompt.select("What is your blood type?", bloods)
        user.update(bloodStatus: blood)
        houses = %w[Gryffindor Slytherin Ravenclaw Hufflepuff]
        house = @@prompt.select("What house do you belong to?", houses)
        user.update(house: house)

    end

    def choose_items
        system("clear")
        items = ["Nimbus 2000", "Invisibility Cloak", "Slightly Dull Sword", "Butter Beer", "Marauder's Map", "Port Key"]
        item_choices = @@prompt.multi_select("Here are some useful items. Please choose two.", items, min: 2, max: 2)
        item_choices.count < 2 ? choose_items : item_choices
    end

    def choose_spells
        system("clear")
        spells = %w[Aguamenti Confringo Confundus Imperio Expelliarmus Crucio]
        spell_choices = @@prompt.multi_select("Would you like to learn some spells?. Here, let me teach two", spells, min: 2, max: 2)
        spell_choices.count < 2 ? choose_spells : spell_choices
    end

    def choose_scenario
        system("clear")
        scenarios = [
            "Join the Death Eaters!", 
            {name: "Fight the Death Eaters!", disabled: "(not ready yet!)"},
            {name: "Find the Sorceror's Stone", disabled: "(not ready yet!)"}
        ]
        scenario_choice = @@prompt.select("Which challenge would you like to take?", scenarios)
        scenario_choice
    end

    def start_scenario(choice)
        if choice == "Join the Death Eaters!"
            scenario = Scenario.create(name: "Death Eaters")
            chars = Character.all.where("deathEater = ?", true).sample(6)
            chars.each {|char| char.update(scenario_id: scenario.id)} 
            user_scenario = UserScenario.create(user: self.user, scenario: scenario)
            user_scenario.scenario.ask_questions
        end
    end





end
