require 'pry'
require 'tty-prompt'
require 'tty-box'
require 'tty-font'
require 'pastel'


class User < ActiveRecord::Base
    has_many :user_scenarios
    has_many :user_spells
    has_many :user_items

    has_many :scenarios, through: :user_scenarios
    has_many :spells, through: :user_spells
    has_many :items, through: :user_items
    belongs_to :game

    @@prompt = TTY::Prompt.new(active_color: :blue)
    @@pastel = Pastel.new

    def self.existing_user(game)
        username = @@prompt.ask(@@pastel.cyan("Please enter you username:"))
        exist_user = User.find_by(username: username)
        if exist_user != nil
            password = @@prompt.mask(@@pastel.cyan("Please enter your password:"))
            count = 0
            while exist_user.password != password
                text_box = TTY::Box.frame(width: 40, height: 3, border: :thick, align: :center) do
                @@pastel.bold.red("Wrong password. Please try again.")
                end
                print text_box
                password = @@prompt.mask(@@pastel.cyan("Please enter your password:"))
                count += 1
                if count == 2
                    message = TTY::Box.frame(width: 40, height: 3, border: :thick, align: :center) do
                    @@pastel.bold.red("Sorry, account has been locked.")
                    end
                    print message
                    game.start_menu(game)
                end
            end
        else
            box = TTY::Box.frame(width: 20, height: 3, border: :thick, align: :center) do
            @@pastel.red("#{username} not found")
            end
            print box
            game.start_menu(game)
        end
        game.update(user: exist_user)
        exist_user
    end


    def self.new_user(game)
        system("clear")
        username = self.create_username
        password = self.create_password
        user = User.create(username: username, password: password)
        game.update(user: user)
        user.user_info
        user
    end

    def self.create_username
        username = @@prompt.ask(@@pastel.green("Please create a new Username:"))
        if User.find_by(username: username) == nil
            username
        else username == User.find_by(username: username).username
            text_box = TTY::Box.frame(width: 25, height: 3, border: :thick, align: :center) do
                @@pastel.on_red("Username already exists.")
            end
            print text_box
            self.create_username
        end
    end

    def self.create_password
        password = @@prompt.mask(@@pastel.green("Please enter a Password:"))
        password_check = @@prompt.mask(@@pastel.green("Please Re-enter Your Password:"))
        if password_check != password
            box = TTY::Box.frame(width: 40, height: 4, border: :thick, align: :center) do
                @@pastel.on_red("We're sorry, but your passwords don't seem to match. Please try again.")
            end
            print box
            self.create_password
        else
            password_check 
        end
    end

    def user_info
        name = self.add_name
        house = self.add_house
        blood = self.add_blood
        self.update(name: name, house: house, bloodStatus: blood)
    end

    def add_house
        box = TTY::Box.frame(width: 40, height: 4, border: :thick, align: :center) do
        @@pastel.underline.magenta("That's an interesting name... I have a few more questions...")
        end
        print box
        houses = %w[Gryffindor Slytherin Ravenclaw Hufflepuff]
        house = @@prompt.select(@@pastel.magenta("What house do you belong to?"), houses)
    end

    def add_blood
        bloods = %w[pure-blood half-blood muggle unkown]
        blood = @@prompt.select(@@pastel.magenta("What is your blood type?"), bloods)
    end

    def add_name
        name = @@prompt.ask(@@pastel.magenta("What is your name, young wizard?"), echo: true)
    end

    def spell_names
        self.spells.map {|spell| spell.spell_name}
    end

    def item_names
        self.items.map {|item| item.name}
    end


    def change_items
        system("clear")
        UserItem.all.where("user_id = ?", self.id).destroy_all
        items = ["Nimbus 2000", "Invisibility Cloak", "Slightly Dull Sword", "Butter Beer", "Marauder's Map", "Port Key"]
        item_choices = @@prompt.multi_select("Here are some useful items. Please choose two.", items, min: 2, max: 2)
        item_choices.count < 2 ? change_items : item_choices
        get_ready_items(item_choices)
    end

    def change_spells
        system("clear")
        UserSpell.all.where("user_id = ?", self.id).destroy_all
        spells = %w[Aguamenti Confringo Confundus Imperio Expelliarmus Crucio]
        spell_choices = @@prompt.multi_select("Would you like to learn some spells?. Here, let me teach two", spells, min: 2, max: 2)
        spell_choices.count < 2 ? change_spells : spell_choices
        get_ready_spells(spell_choices)
    end

    def get_ready_items(item_names)
        item_one_id = Item.find_by(name: item_names[0]).id
        item_two_id = Item.find_by(name: item_names[1]).id
        UserItem.create(user_id: self.id, item_id: item_one_id)
        UserItem.create(user_id: self.id, item_id: item_two_id)
        self.game.navigation_menu
    end

    def get_ready_spells(spell_names)
        spell_one_id = Spell.find_by(spell_name: spell_names[0]).id
        spell_two_id = Spell.find_by(spell_name: spell_names[1]).id
        UserSpell.create(user_id: self.id, spell_id: spell_one_id)
        UserSpell.create(user_id: self.id, spell_id: spell_two_id)
        self.game.navigation_menu
    end

end