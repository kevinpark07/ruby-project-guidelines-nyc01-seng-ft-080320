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
        self.banner
        self.intro_scene
        self.start_menu(self)
        self.user_welcome
        self.navigation_menu
    end

    def banner
        system("clear")
        box = TTY::Box.frame(width: 50, height: 12, border: :thick, align: :center, padding: 2) do
            @@pastel.bold.green("WELCOME TO HOGWARTS! \nTHE DEFINITIVE RPG EXPERIENCE\n\n\n Created by: \nAnson Nickel and Kevin Park, 2020")
            end
            print box
            sleep(4)
    end

    def intro_scene
        system ("clear")
        box = TTY::Box.frame(width: 50, height: 8, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.green("Hello, I am Professor Minerva McGonagall. There have been many curious and dangerous occurences in these halls.")
        end
        print box
    end

    def start_menu(game)
        @@prompt.select(@@pastel.bold.underline.blue("Please Log into the system:"), per_page: 3) do |menu|
            menu.choice @@pastel.green("Create a New Log-in"), -> { User.new_user(game) }
            menu.choice @@pastel.cyan("Log-in"), -> { User.existing_user(game) }
            menu.choice @@pastel.red("Exit"), -> { end_message }
        end
    end

    def user_welcome
        message = TTY::Box.frame(width: 30, height: 4, border: :thick, align: :center) do 
            @@pastel.bold.white("Welcome #{self.user.name}! Let's explore.")
            end
        print message
        sleep(2)
    end

    def navigation_menu
        system ("clear")
        @@prompt.select(@@pastel.bold.underline.blue("What do you want to do?"), per_page: 7) do |menu|
            menu.choice @@pastel.white("User Profile"), -> { self.user.profile }
            menu.choice @@pastel.yellow("View Current Items"), -> { view_items }
            menu.choice @@pastel.yellow("Add/Change Items"), -> { update_items }
            menu.choice @@pastel.cyan("View Current Spells"), -> { view_spells }
            menu.choice @@pastel.cyan("Add/Change Spells"), -> { update_spells }
            menu.choice @@pastel.green("Choose Scenario"), -> { choose_scenario }
            menu.choice @@pastel.red("Exit"), -> { end_message }
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

    def end_message
        system("clear")
        box = TTY::Box.frame(width: 50, height: 16, border: :thick, align: :center, padding: 2) do
            @@pastel.bold.green("Thank you for joining us on this magical journey! We want to give thanks to PotterAPI.com by Kristen Spencer and TTY tool-kit by Piotr Murach. \n\nPlease play again in the future.\n\n\nCreated by: \nAnson Nickel and Kevin Park, 2020")
        end
        print box
        sleep(7)
        system("clear")
        exit
    end

end





    # def banner2
    #    puts 
    #    "
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMWWMMWWMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMWWXOOXWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNWMMMM
            # MMMNKOkkOOO0XNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXOOXMMMM
            # MWWWX0OO0K0OOO0000KXXXXNNNWWWWNNNNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWNX0kxdx0NMMMM
            # MMMMMWX0OkkO00000000000KKKKKKKKKKKKK00K00KKKXNWWXNNNWMWNXNWWNNNNNWWWWWWWWNNWWNWNNXKK00Okdodk0XWMMMMM
            # MMMMMMMMWNKOkdlodddxxxxkkkkkkkkkkkO00KXKK0kod0X0kkkO0KKKOOK00KKKXXXXXXXXXXKKKKKKK0OOkxxk0KNWMMMMMMMM
            # MMMMMMMMWWWMWX0Oxoolccccccccc:;;c:cccodOK0kdkKKKK000KK0OlcxkOKXXXXXXXXXXXXXXXX00OkkkOKXWMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMWXKkddcclcccccc:cc:::okOkkO0K00KX0Oxxkd:,:xOkk0XNNNNXXXXK00xdoodk0NWMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMWNKKK0kxxxdddodk0NMXO0KKKXXX0kdl:::;;oONWXOkkkkkkxkkOOOO0KNWMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWMMMW0OKXNNWNNXXKO:..'ckOKMMMWNXXXNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMW0O0KKXXXNXXXKxc;;okkKMWMWWMMMMMWWWWMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0kO00OOKXXKkc,.'lkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkkkO0OO0koc'.'cd0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKkkOxool::',lkXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkkxdxx0NWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
            # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
    #         "
    # end    
