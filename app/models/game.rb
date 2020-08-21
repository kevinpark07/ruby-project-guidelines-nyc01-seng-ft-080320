require 'pry'
require 'tty-prompt'
require 'tty-box'
require 'tty-font'
require 'pastel'




class Game < ActiveRecord::Base
    has_one :user

    @@prompt = TTY::Prompt.new(active_color: :green)
    @@pastel = Pastel.new
    # @@font = TTY::Font.new(:starwars)

    def start
        system ("clear")
        # banner
        box = TTY::Box.frame(width: 50, height: 8, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.green("Hello, I am Professor Minerva McGonagall. There have been many curious and dangerous occurences in these halls.")
        end
        print box
        system ("cls")
        user = start_menu(self)
        message = TTY::Box.frame(width: 30, height: 4, border: :thick, align: :center) do 
        @@pastel.bold.white("Welcome #{self.user.name}! Let's explore.")
        end
        print message
        navigation_menu
    end

    def start_menu(game)
        #@@font name
        @@prompt.select(@@pastel.bold.underline.blue("Please Log into the system:"), per_page: 3) do |menu|
            menu.choice @@pastel.green("Create a New Log-in"), -> { User.new_user(game) }
            menu.choice @@pastel.cyan("Log-in"), -> { User.existing_user(game) }
            menu.choice @@pastel.magenta("Exit"), -> { exit }
        end
    end

    
    
    def navigation_menu
        system ("clear")
        @@prompt.select(@@pastel.bold.underline.blue("What do you want to do?")) do |menu|
            menu.choice @@pastel.yellow("View Current Items"), -> { view_items }
            menu.choice @@pastel.yellow("Add/Change Items"), -> { update_items }
            menu.choice @@pastel.cyan("View Current Spells"), -> { view_spells }
            menu.choice @@pastel.cyan("Add/Change Spells"), -> { update_spells }
            menu.choice @@pastel.green("Choose Scenario"), -> { choose_scenario }
            menu.choice @@pastel.red("Exit"), -> { exit }
        end
    end

    def view_items
        system ("clear")
        if  User.all.select {|user| user.game_id == self.id}.first.user_items == []
        message = TTY::Box.frame(width: 30, height: 3, border: :thick, align: :center) do  
        @@pastel.bold.yellow("Sorry, you have no items.")
        end
        print message
        else
            text_box = TTY::Box.frame(width: 30, height: 3, border: :thick, align: :center) do
            @@pastel.yellow("Here are your current items")
            end
            print text_box
            uis = User.all.select {|user| user.game_id == self.id}.first.user_items
            uis.each {|ui| puts @@pastel.yellow("#{ui.item.name}: #{ui.item.description}")}
        end
        @@prompt.select(@@pastel.bold.underline.blue("Go back to previous menu?")) do |menu|
            menu.choice @@pastel.underline.yellow("Back"), -> { navigation_menu }
        end
    end


    def view_spells
        system ("clear")
        if User.all.select {|user| user.game_id == self.id}.first.user_spells == []
            message = TTY::Box.frame(width: 30, height: 3, border: :thick, align: :center) do
            @@pastel.bold.cyan("Sorry, you have no spells.")
            end
            print message
        else
            text_box = TTY::Box.frame(width: 30, height: 3, border: :thick, align: :center) do 
            @@pastel.cyan("Here are your current spells")
            end
            print text_box
            us = User.all.select {|user| user.game_id == self.id}.first.user_spells
            us.each {|us| puts @@pastel.cyan("#{us.spell.spell_name}: #{us.spell.effect_name}")}
        end
        @@prompt.select(@@pastel.bold.underline.blue("Go back to previous menu?")) do |menu|
            menu.choice @@pastel.white("Back"), -> {navigation_menu}
        end
    end

    def update_items
        system ("clear")
        result = @@prompt.select(@@pastel.bold.underline.blue("Would you like to add or change items?")) do |menu|
            menu.choice @@pastel.yellow("Add/Change"), -> { self.user.change_items }
            menu.choice @@pastel.yellow("Back"), -> { navigation_menu }
        end
    end

    def update_spells
        system ("clear")
        result = @@prompt.select(@@pastel.bold.underline.blue("Would you like to add or change spells?")) do |menu|
            menu.choice @@pastel.cyan("Add/Change"), -> { self.user.change_spells }
            menu.choice @@pastel.cyan("Back"), -> { navigation_menu }
        end
    end


    def choose_scenario
        system("clear")
        if self.user.is_ready?
            scenarios = [
                "Join the Death Eaters!", 
                {name: "Fight the Death Eaters!", disabled: "(not ready yet!)"},
                {name: "Find the Sorceror's Stone", disabled: "(not ready yet!)"}
            ]
            scenario_choice = @@prompt.select(@@pastel.bold.underline.blue("Which challenge would you like to take?"), scenarios)
            choice = scenario_choice
            start_scenario(choice)
        else
            box = TTY::Box.frame(width: 50, height: 4, border: :thick, align: :center) do
            @@pastel.bold.red("Please select items and spells before embarking on a scenario!")
            end
            print box 
            sleep(2)
            self.navigation_menu
        end
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


#     def banner
#         box = TTY::Box.frame(width:160, height:15, border: :thick, align: :center) do 
#         "
#         __          __         _                                       _               _    _                                             _           _ 
#         \ \        / /        | |                                     | |             | |  | |                                           | |         | |
#          \ \  /\  / /    ___  | |   ___    ___    _ __ ___     ___    | |_    ___     | |__| |   ___     __ _  __      __   __ _   _ __  | |_   ___  | |
#           \ \/  \/ /    / _ \ | |  / __|  / _ \  | '_ ` _ \   / _ \   | __|  / _ \    |  __  |  / _ \   / _` | \ \ /\ / /  / _` | | '__| | __| / __| | |
#            \  /\  /    |  __/ | | | (__  | (_) | | | | | | | |  __/   | |_  | (_) |   | |  | | | (_) | | (_| |  \ V  V /  | (_| | | |    | |_  \__ \ |_|
#             \/  \/      \___| |_|  \___|  \___/  |_| |_| |_|  \___|    \__|  \___/    |_|  |_|  \___/   \__, |   \_/\_/    \__,_| |_|     \__| |___/ (_)
#                                                                                                          __/ |                                          
#                                                                                                         |___/                                           
#        "end
#        print box
#     end     
end