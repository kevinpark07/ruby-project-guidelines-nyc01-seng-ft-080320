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
        start_menu
        puts "Welcome to Hogwarts! My name is Argus Filch. There have been many curious and dangerous occurences in these halls."
        # existing = @@prompt.select("Have you played with us before?", %w(Yes No))
        # if existing == "Yes" ? self.existing_user : self.new_user
        puts "Welcome #{self.user.name}! Let's explore"
        # self.navigation_menu
        self.new_game
    end

    def start_menu
        #@@font name
        @@prompt.select("Welcome to the start menu.", per_page: 3) do |menu|
            menu.choice "Create a New Log-in", -> { new_user }
            menu.choice "Log-in", -> { existing_user }
            menu.choice "Exit", -> { exit }
        end
    end
    

    
    def navigation_menu
        #@@font name
        @@prompt.select(@@pastel.green("Welcome, what do you want to do?"), per_page: 6) do |menu|
            menu.choice "View Current Items", -> { view_items }
            menu.choice "Change Current Items", -> { change_items }
            menu.choice "View Current Spells", -> { view_spells }
            menu.choice "Change Current Spells", -> { change_spells }
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

    def change_items
        result = @@prompt.select("Would you like to change items?", %w[Yes No])
        if result == "Yes"
            items = UserItem.all.find_all {|ui| ui.user_id == self.user.id}
            items[0].delete
            items[1].delete
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



    def existing_user
        username = @@prompt.ask("Please enter you username >>")
        password = @@prompt.mask("Please enter your password >>")
        user = User.all.find_by(username: username, password: password)
        if user == nil
            puts "Sorry, your name and/or password was not found. Please try again."
            self.existing_user 
        else
            user.game = self
        end
        self.navigation_menu
    end

    def new_user #updated
        system("clear")
        create_new_user
        name = @@prompt.ask("What is your name, young wizard? >>", echo: true)
        self.user.name = name
        puts "Hi #{self.user.name}! Interesting name. A few more questions..."
        bloods = %w[pure-blood half-blood muggle unkown]
        blood = @@prompt.select("What is your blood type?", bloods)
        user.update(bloodStatus: blood)
        houses = %w[Gryffindor Slytherin Ravenclaw Hufflepuff]
        house = @@prompt.select("What house do you belong to?", houses)
        user.update(house: house)
        user
    end

    def create_new_user #new
        # system("clear")
        create_username
        password = @@prompt.mask("Please enter a Password:")
        password_check = @@prompt.mask("Please Re-enter Your Password:")
        if password_check != password
            puts "We're sorry, but you passwords don't seem to match. Please try again"
            password = @@prompt.mask("Please enter a Password:")
            password_check = @@prompt.mask("Please Re-enter Your Password:")
            user.update(password: password_check)
        else
            user.update(password: password_check)
        end
        binding.pry
    end

    def create_username
        username = @@prompt.ask("Please enter a Username >>")
        user = User.create(username: username)
        user.game = self
    end


    
    def new_game
        system("clear")
        items = self.choose_items
        spells = self.choose_spells
        self.user.get_ready(items, spells)
        self.navigation_menu
        # result = @@prompt.select("Would you like to review your selections or continue?", %w(Review Continue))
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

    # def review_selection
    #     choice = %w[Items Spells Exit]
    #     result = @@prompt.select("Please select one to review.", choice)
    #     if result == "Items"
    #         result = @@prompt.select("Would you like to get new items?", %w[Yes No])
    #         if result == "Yes"
    #             items = User_items.all.find_by(user_id: self.user.id)
    #             items.destroy
    #             self.choose_items
    #             self.review_selection
    #         else
    #             self.review_selection
    #         end
    #     elsif result == "Spells"
    #         result = prompt.select("Would you like to learn new spells?", %w[Yes No])
    #         if result == "Yes"
    #             spells = User_spells.all.find_by(user_id: self.user.id)
    #             spells.destroy
    #             self.choose_spells
    #             self.review_selection
    #         else
    #             self.review_selection
    #         end
    #     end
    # end

                
end




