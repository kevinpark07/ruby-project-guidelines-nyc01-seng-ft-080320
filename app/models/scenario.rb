require 'tty-prompt'

class Scenario < ActiveRecord::Base

    has_many :characters
    has_many :user_scenarios
    has_many :users, through: :user_scenarios
    @@prompt = TTY::Prompt.new

    def ask_questions
        score = 0
        score = question_one(score)
        score = question_two(score)
        score = question_three(score)
        score = question_four(score)
        score = question_five(score)
        score = question_six(score)
        win?(score)
    end

    def question_one(score)
        system("clear")
        puts "As you enter the Death Eater office, you spot #{self.characters[0].name} in a dark corner."
        choice = %w[pure-blood half-blood muggle unkown]
        result = @@prompt.select("#{self.characters[0].name} asks: Hello #{self.users[0].name}! What is your blood type?", choice)
        if result == self.characters[0].bloodStatus 
            score += 1
        else
            score
        end
        score
    end

    def question_two(score)
        system("clear")
        puts "After appeasing #{self.characters[0].name}, you shiver as you pass by #{self.characters[1].name}."
        choice = self.users[0].spells.map {|spell| spell.spell_name}
        result = @@prompt.select("#{self.characters[1].name} asks: Hello #{self.users[0].name}! Which of the spells that you've learned would you use against an opponent?", choice)
        if Spell.find_by(spell_name: result).category == "Curse"
            puts "I see you love your Curses. So do I!"
            score += 1
        else
            puts "What a shame. We love Curses here at the Death Eater office."
            score
        end
        score
    end

    def question_three(score)
        system("clear")
        puts "#{self.characters[2].name} sees you walking down the hall and gives you a strange look."
        result = @@prompt.select("Hey kid! You got any beverages for me? All this Death Eating has made me mighty thirsty.", %w[Yes No])
        butter = Item.find_by_name("Butter Beer")
        if result == "Yes" && !self.user.items.include?(butter)
            puts "Ha! You liar! I applaud your chutz-pah"
            score += 1
        elsif result == "Yes" && self.user.items.include?(butter)
            beer = self.user.user_items.find_by(item_id: butter.id)
            beer.destroy
            puts "I'll take that! You're too young anyways."
            score += 1
        else 
            puts "Bah! What a waste you are."
            score
        end
        score
    end

    def question_four(score)
        system("clear")
        choice = %w[Gryffindor Ravenclaw Slytherin Hufflepuff]
        result = @@prompt.select("#{self.characters[3].name} glares at you and asks: What house are you in anyway?", choice)
        if result == self.user.house && result == "Slytherin"
            puts "Impressive, I have a good feeling about you."
            score += 1
        elsif result != self.user.house
            puts "You don't think I know you're lying! Unlike #{self.characters[2].name}, I HATE LIARS! You disgust me!"
            score -= 1
        else
            "Yuck. We prefer Slytherins."
            score
        end
        score
    end

    def question_five(score)
        system("clear")
        choice = %w[Voldemort Dumbledore Potter Grindelwald]
        result = @@prompt.select("You run to use the bathroom when #{self.characters[4].name} sees you and asks: Who do you think is the greatest wizard of all time?", choice)
        if result == "Voldemort" || result == "Grindelwald"
            puts "Hmmmmm... Excellent choice. But that was an easy question! Don't think I'm impressed."
            score += 1
        else
            puts "WHAT!? You must be joking! Do you know where you are right now? Get out of my face!"
            score -=1
        end
        score
    end

    def question_six(score)
        system("clear")
        puts "As you exit the bathroom,  #{self.characters[5].name} is standing right ouside waiting for you." 
        choice = %w[Accept Decline]
        result = @@prompt.select("Hey kid, why don't you and I have a quick duel? It could be funnnn... Don't be scared.", choice)
        if result == "Accept"
            puts "You might not be as weak as I thought. Maybe you would make a Death Eater."
            score +=1
        else
            puts "You're weak. I never expected much from you anyway."
            score
        end
        score
    end

    def win?(score)
        if score > 4
            you_won
        else
            you_lost
        end
        self.user.game.navigation_menu
    end

    def you_won
        puts "Voldemort comes out from his office and gives you a nice warm hug."
        puts "Welcome #{self.user.name} to the Death Eaters!"
    end

    def you_lost
        puts "Voldemort's assistant walks up to you and requests that you leave the premises. Sorry, you did not become a Death Eater."
    end

    def user
         UserScenario.all.where("scenario_id = ?", self.id).first.user
    end
    

end