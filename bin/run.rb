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
    user = User.create(name: name)
    puts "Hi #{user.name}! Interesting name. Let's get you set up to explore."
    puts "First, let's get you some items. We're a bit under-resourced, so you can only choose two."
    list_items
    puts "Type the name of the item you wish to receive."
    item1 = gets.chomp
    user_item1 = user.pick_item(Item.find_by(name: item1))
    puts "Great choice! Now choose one more."
    item2 = gets.chomp
    user_item2 = user.pick_item(Item.find_by(name: item1))


end

def list_items
    count = 0
    while count < Item.all.count
    Item.all.each_with_index do |item, index|
        puts "#{index +1}. #{item.name}: #{item.description}"
    end
end


    

end



