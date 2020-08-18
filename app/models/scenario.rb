class Scenario < ActiveRecord::Base
    has_many :user_scenarios
    has_many :users, through: :user_scenarios

    def start_scenario
        puts "Dumbledore has asked you to retieve the Sorceror's Stone. Do you accept this mission? (y/n)"
        input = gets.chomp 
        if input != "y"
            puts "Ok, please let me know when you're ready to accept."
        elsif input != 'y' && input != 'n'
            puts "I'm sorry, I can't read your handwriting. Please use 'y' or 'n'"
            start_scenario
        elsif input == "y" 
            puts "Excellent! Good Luck!"
        end
        event1
    end
    
    def event1
        puts "You walkdown the hidden corridor that Dumbledore instructed you to follow. At the end of the hall you encounter a locked door. How will you unlock it?"
        us = UserScenario.all.where("scenario_id = ?", self.id).first
        binding.pry
        us.user.options
        input = gets.chomp
        if input != "Alohamora"
            puts "Nothing happened! The door is still locked! Try again."
            event1
        elsif input == "Alohamora"
            puts "The door is opened! You walk in to see a three-headed dog sleeping next to a trap door. You must get passed the dog and through the trap door! What will you use?"
            event2
        end
    end

    def event2
        us = UserScenario.all.where("scenario_id = ?", self.id).first
        us.user.options
        input = gets.chomp
        if input != "Invisibility Cloak"
            puts "Oh no, you almost woke up Fluffy! Try again, and be careful!"
            event2
        elsif input == "Invisibility Cloak"
            puts "You cloak youself from Fluffy and sneak passed him to the trap door. You open up the door and jump down into a bed of vines! You begin to stuggle to get out but the vines are getting tighter! You feel that it is starting to pull you down! "
            event3
        end
    end

    def event3
        puts "Do you relax and let it take you? (y/n)"
        input = gets.chomp
        if input != "y"
            puts "You continue to stuggle and the vines get tighter! You're having trouble breathing!"
            event3
        elsif input != 'y' && input != 'n'
            puts "I'm sorry, I can't read your handwriting. Please use 'y' or 'n'"
            event3
        elsif input == "y"
            puts "The vines loosen and you fall right through. You land in a hallway with a single door. You walk to the door and open it to see hundreds of flying keys up above the room! There is a door at the other end of the room but it's locked. One of the keys must open the door! But, which one? Floating along, you see one of the keys damaged as if someone else has already used it! That must be the one! But, how will you grab it when they're all flying in the air?"
            event4
        end
    end

    def event4
        us = UserScenario.all.where("scenario_id = ?", self.id).first
        us.user.options
        input = gets.chomp
            if input != "Nimbus 2000" || "accio"
                puts "Nothing happened. The keys continue to fly and you're stuck on the ground"
                event4
            elsif input == "Nimbus 2000" || "accio"
                puts "You got the key! You use the key to open the door and you find yourself in another corridor with a goblin at the end standing in front of the door. He looks tired and will not let you pass! He is a stubborn one! What item can you give him?"
                event5
            end
    
    end

    def event5
        us = UserScenario.all.where("scenario_id = ?", self.id).first
        us.user.options
        input = gets.chomp
        if input != "Butter Beer"
            puts "Oh no, you've just made him angrier! What can you give him, he seems a bit parched?"
            event5
        elsif input == "Butter Beer"
            puts "He takes the drink joyfully and chugs it down quickly. After chatting for a bit, the goblin passes out, cold. You walk through the door and you see Professor Quarral!? He's holding on to the Sorcerer's Stone! He's surprised to see you! You have a only a moment to strike!"
        end
    end

    def event6
        us = UserScenario.all.where("scenario_id = ?", self.id).first
        us.user.options
        input = gets.chomp
            if input != "Expelliarmus"
                puts "Oh no! That's not the right choice! Try again beofre he escapes!"
                event6
            elsif input == "Expelliarmus"
                puts "The Scorcer's Stone is expelled from Professor Quarral's hand and land right in yours! With the stone, you run out of the room lock the door behind you! You successfully return the stone to Dumbledore! Congratulations, you did it!"
            end
    end





end