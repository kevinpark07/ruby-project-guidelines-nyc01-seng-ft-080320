require 'tty-prompt'
require 'tty-box'
require 'tty-font'
require 'pastel'

class Scenario < ActiveRecord::Base

    has_many :characters
    has_many :user_scenarios
    has_many :users, through: :user_scenarios
    
    @@prompt = TTY::Prompt.new(active_color: :green)
    @@pastel = Pastel.new

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
        box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center) do
        @@pastel.bold.green("As you enter the Death Eater office, you spot #{self.characters[0].name} in a dark corner.")
        end
        print box 
        choice = %w[pure-blood half-blood muggle unkown]
        result = @@prompt.select(@@pastel.bold.underline.magenta("#{self.characters[0].name} asks: Hello #{self.users[0].name}! What is your blood type?"), choice)
        if result == self.characters[0].bloodStatus 
            score += 1
        else
            score
        end
        score
    end

    def question_two(score)
        system("clear")
        box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.green("After appeasing #{self.characters[0].name}, you shiver as you pass by #{self.characters[1].name}.")
        end
        print box
        choice = self.users[0].spells.map {|spell| spell.spell_name}
        result = @@prompt.select(@@pastel.bold.underline.magenta("#{self.characters[1].name} asks: Hello #{self.users[0].name}! Which of the spells that you've learned \nwould you use against an opponent?"), choice)
        if Spell.find_by(spell_name: result).category == "Curse"
            message = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("I see you love your Curses. So do I!")
            end
            print message
            sleep(4)
            score += 1
        else
            box_text = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("What a shame. We love Curses here at the Death Eater office.")
            end
            print box_text
            sleep(4)
            score
        end
        score
    end

    def question_three(score)
        system("clear")
        box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.green("#{self.characters[2].name} sees you walking down the hall and gives you a strange look.")
        end
        print box
        result = @@prompt.select(@@pastel.bold.underline.magenta("Hey kid! You got any beverages for me? All this Death \nEating has made me mighty thirsty."), %w[Yes No])
        butter = Item.find_by_name("Butter Beer")
        if result == "Yes" && !self.user.items.include?(butter)
            message = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("Ha! You liar! I applaud your chutz-pah")
            end
            print message
            sleep(4)
            score += 1
        elsif result == "Yes" && self.user.items.include?(butter)
            beer = self.user.user_items.find_by(item_id: butter.id)
            beer.destroy
            box_text = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("I'll take that! You're too young anyways.")
            end
            print box_text
            sleep(4)
            score += 1
        else 
            text_box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("Bah! What a waste you are.")
            end
            print text_box
            sleep(4)
            score
        end
        score
    end

    def question_four(score)
        system("clear")
        box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.green("#{self.characters[3].name} glares at you and with a snarl asks:")
        end
        print box
        choice = %w[Gryffindor Ravenclaw Slytherin Hufflepuff]
        result = @@prompt.select(@@pastel.bold.underline.magenta( "What house are you in anyway?"), choice)
        if result == self.user.house && result == "Slytherin"
            text_box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("Impressive, I have a good feeling about you.")
            end
            print text_box
            sleep(4) 
            score += 1
        elsif result != self.user.house
            box_text = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("You don't think I know you're lying! Unlike #{self.characters[2].name}, I HATE LIARS! You disgust me!")
            end
            print box_text
            sleep(4)
            score -= 1
        else
            message = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("Yuck. We prefer Slytherins.")
            end
            print message
            sleep(4)
            score
        end
        score
    end

    def question_five(score)
        system("clear")
        box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.green("You run to use the bathroom when #{self.characters[4].name} sees you and asks:")
        end
        print box 
        choice = %w[Voldemort Dumbledore Potter Grindelwald]
        result = @@prompt.select(@@pastel.bold.underline.magenta("Who do you think is the greatest wizard of all time?"), choice)
        if result == "Voldemort" || result == "Grindelwald"
            message = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("Hmmmmm... Excellent choice. But that was an easy question! Don't think I'm impressed.")
            end
            print message
            sleep(4)
            score += 1
        else
            text_box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("WHAT!? You must be joking! Do you know where you are right now? Get out of my face!")
            end
            print text_box
            sleep(4)
            score -=1
        end
        score
    end

    def question_six(score)
        system ("clear")
        box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.green("As you exit the bathroom, #{self.characters[5].name} is standing right ouside waiting for you.")
        end
        print box 
        choice = %w[Accept Decline]
        result = @@prompt.select(@@pastel.bold.underline.magenta("Hey kid, why don't you and I have a quick duel? \nIt could be funnnn... Don't be scared."), choice)
        if result == "Accept"
            message = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("You might not be as weak as I thought. Maybe you would make a Death Eater.")
            end
            print message
            sleep(4)
            score +=1
        else
            text_box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
            @@pastel.bold.blue("You're weak. I never expected much from you anyway.")
            end
            print text_box
            sleep(4)
            score
        end
        score
    end

    def win?(score)
        system ("clear")
        if score > 4
            you_won
        else
            you_lost
        end
        sleep(5)
        self.user.game.navigation_menu
    end

    def you_won
        box = TTY::Box.frame(width: 50, height: 10, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.cyan("Voldemort comes out from his office and gives you a nice warm hug. Welcome #{self.user.name} to the Death Eaters!")
        end
        print box
    end

    def you_lost
        box = TTY::Box.frame(width: 50, height: 10, border: :thick, align: :center, padding: 1) do
        @@pastel.bold.cyan("Voldemort's assistant walks up to you and requests that you leave the premises. Sorry, you did not become a Death Eater.")
        end
        print box
    end

    def user
         UserScenario.all.where("scenario_id = ?", self.id).first.user
    end
    
    #not used...yet
    # def next_question
    #     system ("clear")
    #     box = TTY::Box.frame(width: 50, height: 6, border: :thick, align: :center, padding: 1) do
    #     @@pastel.bold.red("Next Question!")
    #     end
    #     print box
    # end

end