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
        start_menu
        puts "Welcome #{self.user.name}! Let's explore"
        navigation_menu
        self.new_game
    end

    def start_menu
        #@@font name
        @@prompt.select("Welcome to the start menu.", per_page: 3) do |menu|
            menu.choice "Create a New Log-in", -> { User.new_user }
            menu.choice "Log-in", -> { User.existing_user }
            menu.choice "Exit", -> { exit }
        end
    end

    def new_game
        system("clear")
        items = self.choose_items
        spells = self.choose_spells
        self.user.get_ready(items, spells)
        self.navigation_menu
        # result = @@prompt.select("Would you like to review your selections or continue?", %w(Review Continue))
        # list table of spells/items
        # @@prompt.select("Congratulations, it looks like you've chosen wisely. Time to choose your objective!", %w(Ok!))
        # choice = choose_scenario
        # start_scenario(choice)
    end
    

    
    def navigation_menu
        #@@font name
        @@prompt.select(@@pastel.green("Welcome, what do you want to do?"), per_page: 5) do |menu|
            menu.choice "View Current Items", -> { view_items }
            menu.choice "View Current Spells", -> { view_spells }
            menu.choice "Change Current Items/Spells", -> { change_items_spells }
            menu.choice "Choose Scenario", -> { choose_scenario }
            menu.choice "Exit", -> { exit }
        end
    end

    def view_items
        # item_box = TTY::Box.frame 
        items = self.user.items.map{|i| i.name}
        items << "Exit"
        descriptions = self.user.items.map{|i| i.description}
        result = @@prompt.select("Click an item for it's description", items)
        if result == items[0]
            p descriptions[0]
            @@prompt.select("Return to Items?", %w[OK!])
            view_items
        elsif result == items[1]
            p descriptions[1]
            @@prompt.select("Return to Items?", %w[OK!])
            view_items
        elsif result == "Exit"
            self.navigation_menu
        end
    end

    def change_items_spells
        result = @@prompt.select("Would you like to change your items and spells?", %w[Yes No])
        if result == "Yes"
            items = UserItem.all.find_all {|ui| ui.user_id == self.user.id}
            spells = UserSpell.all.find_all {|us| us.user_id == self.user.id}
            binding.pry
            items[0].destroy
            items[1].destroy
            spells[0].destroy
            spells[1].destroy
            binding.pry
            self.new_game
        elsif result == "No"
            self.navigation_menu
        end
    end

    def view_spells
        # item_box = TTY::Box.frame 
        spells = self.user.spells.map{|s| s.spell_name}
        spells << "Exit"
        effects = self.user.spells.map{|s| s.effect_name}
        result = @@prompt.select("Click an spell for it's effect", spells)
        if result == spells[0]
            p effects[0]
            @@prompt.select("Return to Spells?", %w[OK!])
            view_spells
        elsif result == spells[1]
            p effects[1]
            @@prompt.select("Return to Spells?", %w[OK!])
            view_spells
        elsif result == "Exit"
            self.navigation_menu
        end
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
