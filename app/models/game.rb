require 'pry'
require 'tty-prompt'
# require 'tty-font'



class Game < ActiveRecord::Base
    has_one :user

    @@prompt = TTY::Prompt.new(active_color: :blue)
    @@pastel = Pastel.new
    # @@font = TTY::Font.new(:starwars)

    def start
        system("clear")
        # puts @@pastel.red(@@font.write("Hogwarts School of Witchcraft & Wizardry"))
        puts "Welcome to Hogwarts! My name is Argus Filch. There have been many curious and dangerous occurences in these halls."
        user = start_menu
        self.update(user: user)
        puts "Welcome #{self.user.name}! Let's explore."
        navigation_menu
    end

    def start_menu
        #@@font name
        @@prompt.select("Welcome to the start menu.", per_page: 3) do |menu|
            menu.choice "Create a New Log-in", -> { User.new_user }
            menu.choice "Log-in", -> { User.existing_user }
            menu.choice "Exit", -> { exit }
        end
    end

    
    
    def navigation_menu
        #@@font name
        @@prompt.select(@@pastel.green("Welcome, what do you want to do?")) do |menu|
            menu.choice "View Current Items", -> { view_items }
            menu.choice "View Current Spells", -> { view_spells }
            menu.choice "Add/Change Items", -> { update_items }
            menu.choice "Add/Change Spells", -> { update_spells }
            menu.choice "Choose Scenario", -> { choose_scenario }
            menu.choice "Exit", -> { exit }
        end
    end

    def view_items
        # item_box = TTY::Box.frame
        #Show box full of items or box with msg saying "Sorry!"
        if  User.all.select {|user| user.game_id == self.id}.first.user_items == []
            puts "Sorry, you have no items. Go back to add items/spells."
        else
            puts "Here are your current items"
            uis = User.all.select {|user| user.game_id == self.id}.first.user_items
            uis.each {|ui| puts "#{ui.item.name}: #{ui.item.description}"}
        end
        @@prompt.select("Go back to previous menu?") do |menu|
            menu.choice "Back", -> { navigation_menu }
        end
    end


    def view_spells
        if User.all.select {|user| user.game_id == self.id}.first.user_spells == []
            puts "Sorry, you have no spells. Go back to add items/spells."
        else
            puts "Here are your current spells"
            us = User.all.select {|user| user.game_id == self.id}.first.user_spells
            us.each {|us| puts "#{us.spell.spell_name}: #{us.spell.effect_name}"}
        end
        @@prompt.select("Go back to previous menu?") do |menu|
            menu.choice "Back", -> {navigation_menu}
        end
    end

    def update_items
        result = @@prompt.select("Would you like to add or change items?") do |menu|
            menu.choice "Add/Change", -> { self.user.change_items }
            menu.choice "Back", -> { navigation_menu }
        end
    end

    def update_spells
        result = @@prompt.select("Would you like to add or change spells?") do |menu|
            menu.choice "Add/Change", -> { self.user.change_spells }
            menu.choice "Back", -> { navigation_menu }
        end
    end


    def choose_scenario
        system("clear")
        scenarios = [
            "Join the Death Eaters!", 
            {name: "Fight the Death Eaters!", disabled: "(not ready yet!)"},
            {name: "Find the Sorceror's Stone", disabled: "(not ready yet!)"}
        ]
        scenario_choice = @@prompt.select("Which challenge would you like to take?", scenarios)
        choice = scenario_choice
        start_scenario(choice)
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