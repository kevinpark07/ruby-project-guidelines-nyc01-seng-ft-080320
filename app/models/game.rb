require 'pry'
require 'tty-prompt'



class Game < ActiveRecord::Base
    has_one :user

    @@prompt = TTY::Prompt.new(active_color: :blue)
    @@pastel = Pastel.new
    #@@font = TTY::Font.new(:starwars)

    def start
        system("clear")
        #puts @@pastel.red(@@font.write("Hogwarts School of Witchcraft & Wizardry"))
        puts "Welcome to Hogwarts! My name is Argus Filch. There have been many curious and dangerous occurences in these halls."
        existing = @@prompt.select("Have you played with us before?", %w(Yes No))
        if existing == "Yes" ? self.existing_user : self.new_user
        puts "Welcome #{self.user.name}! Let's explore"
        self.new_game
    end

    def existing_user
        name = @@prompt.ask("Please enter you name:")
        password = @@prompt.ask("Please enter your password:")
        user = User.all.find_by(name: name, password: password)
        if user == nil
            puts "Sorry, your name and/or password was not found. Please try again."
            self.start 
        else
            user.game = self
        end
        user
    end

    def new_user
        system("clear")
        name = @@prompt.ask("What is your name, young wizard?", echo: true)
        password = @@prompt.ask("Please enter a password:")
        user = User.create(name: name, password: password)
        user.game = self
        puts "Hi #{self.user.name}! Interesting name. A few more questions..."
        bloods = %w[pure-blood half-blood muggle unkown]
        blood = @@prompt.select("What is your blood type?", bloods)
        user.update(bloodStatus: blood)
        houses = %w[Gryffindor Slytherin Ravenclaw Hufflepuff]
        house = @@prompt.select("What house do you belong to?", houses)
        user.update(house: house)
        user
    end

    
    def new_game
        system("clear")
        items = self.choose_items
        spells = self.choose_spells
        self.user.get_ready(items, spells)
        result = @@prompt.select("Would you like to review your selections or continue?", %w(Review Continue))
        # list table of spells/items
        @@prompt.select("Congratulations, it looks like you've chosen wisely. Time to choose your objective!", %w(Ok!))
        choice = choose_scenario
        start_scenario(choice)
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

    def review_selection
        choice = %w[Items Spells Exit]
        result = @@prompt.select("Please select one to review.", choice)
        if result == "Items"
            choice = %w[Yes No]
            result = @@prompt.select("Would you like to get new items?", choice)
            if result == "Yes"
                items = User_items.all.find_by(user_id: self.user.id)
                items.destroy
                self.choose_items
                self.review_selection
            else
                self.review_selection
            end
        elsif result == "Spells"
            result = prompt.select("Would you like to learn new spells?", %w[Yes No])
            if result == "Yes"
                spells = User_spells.all.find_by(user_id: self.user.id)
                spells.destroy
                self.choose_spells
                self.review_selection
            else
                self.review_selection
            end
        end
    end


                
end




