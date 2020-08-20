require 'pry'

class User < ActiveRecord::Base
    has_many :user_scenarios
    has_many :user_spells
    has_many :user_items
    has_many :scenarios, through: :user_scenarios
    has_many :spells, through: :user_spells
    has_many :items, through: :user_items
    belongs_to :game

    @@prompt = TTY::Prompt.new(active_color: :blue)

    def self.existing_user
        username = @@prompt.ask("Please enter you username:")
        exist_user = User.find_by(username: username)
        if exist_user
            password = @@prompt.mask("Please enter your password:")
            count = 0
            while exist_user.password != password
                puts "Wrong password. Please try again."
                password = @@prompt.mask("Please enter your password:")
                count += 1
                if count == 2
                    puts "Sorry, account has been locked."
                    return false
                end
            end
        else
            puts "#{username} not found"
            return false
        end
    end


    def self.new_user
        system("clear")
        username = self.create_username
        password = self.create_password
        game = Game.last
        user = User.create(username: username, password: password)
        game.update(user: user)
        binding.pry
        user.user_info
    end

    def self.create_username
        username = @@prompt.ask("Please create a new Username:")
        if User.find_by(username: username) == nil
            username
        else username == User.find_by(username: username).username
            puts "Username already exists."
            self.create_username
        end
    end

    def self.create_password
        password = @@prompt.mask("Please enter a Password:")
        password_check = @@prompt.mask("Please Re-enter Your Password:")
        if password_check != password
            puts "We're sorry, but your passwords don't seem to match. Please try again"
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
        puts "Hi #{self.name}! Interesting name. A few more questions..."
        houses = %w[Gryffindor Slytherin Ravenclaw Hufflepuff]
        house = @@prompt.select("What house do you belong to?", houses)
    end

    def add_blood
        bloods = %w[pure-blood half-blood muggle unkown]
        blood = @@prompt.select("What is your blood type?", bloods)
    end

    def add_name
        name = @@prompt.ask("What is your name, young wizard?", echo: true)
    end








        # user = User.all.find_by(username: username, password: password)
        # if user == nil
        #     puts "Sorry, your name and/or password was not found. Please try again."
        #     self.existing_user 
        # else
        #     user.game = self
        # end
        # self.navigation_menu



    def spell_names
        self.spells.map {|spell| spell.spell_name}
    end

    def item_names
        self.items.map {|item| item.name}
    end

    def get_ready(items, spells)
        items.each {|item| UserItem.create(user_id: self.id, item_id: Item.find_by_name(item).id)}
        spells.each {|spell| UserSpell.create(user_id: self.id, spell_id: Spell.find_by(spell_name: spell).id)}
    end


end