require_relative '../config/environment'


def start?()
    puts "Welcome to Hogwarts! My name is Argus Filch. There have been many curious and dangerous occurences in these halls."
    puts "Would you like to explore? (y/n)"
    input = gets.chomp
    if input == 'n'
        puts "Well, that's no fun! Have a good day."
    elsif input != 'y' && input != 'n'
        puts "I'm sorry, I can't read your handwriting. Please use 'y' or 'n'"
        start?()
    elsif input == 'y'
        game()
    end
end

def game
    puts "What is your name, young one?"
    name = gets.chomp
    puts "Hi #{nane}! Interesting name. Let's get you set up to explore."
    puts "First, let's get you some items. We're a bit under-resourced, so you can only choose two."
    list_items

    

end



