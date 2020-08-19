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
        score = question_three(score)
        score = question_three(score)
        score = question_three(score)
        win?(score)
        binding.pry
    end

    def question_one(score)
        choice = %w[pure-blood half-blood muggle unkown]
        result = @@prompt.select("#{self.characters[0].name} asks: Hello #{self.users[0].name}! What is your blood type?", choice)
        if result == self.characters[0].bloodStatus 
            score += 1
        else
            score
        end
    end

    def question_two(score)
        choice = %w[]
        result = @@prompt.select("#{self.characters[1].name} asks: Hello #{self.users[0].name}! Which of the spells that you've learned would you use against an opponent?", choice)
        if result == self.characters[0].bloodStatus 
            score += 1
        else
            score
        end
    end

    def question_three(score)
    end

    def question_four(score)
    end

    def question_five(score)
    end

    def question_six(score)
    end

    def win?(score)
    end

    #add method to find User through UserScenario

    

end