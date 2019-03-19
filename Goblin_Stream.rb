

require_relative "./Create_Characters.rb"
require_relative "./Character_AI.rb"

include Create_Characters
#include Character_AI


def start(char_1, monster)
    puts "Beginning #{char_1.name}'s goblin stream."
    monsters_killed = 0
    turn = sort_initiative(char_1, monster)
    while (char_1.hit_points > 0)
        puts "************************************************"
        puts "A goblin appears: (#{monster.hit_points}HP)"
        result = fight(char_1, monster, turn) 
        if (result == "Win")
            monsters_killed += 1
            puts "Amber has killed a goblin!"
            puts "#{char_1.name}'s remaining HP: #{char_1.hit_points}"
            monster.set_max_HP()
            monster.set_HP_to_max()
        elsif  (result == "Lose")
            puts "#{char_1.name} dies."
            puts "#{char_1.name} killed #{monsters_killed} goblins."
            break
        else
            puts "There has been a problem: result should be a win or loss."
            break
        end
    end
    return monsters_killed
end


def sort_initiative(char_1, char_2)
    char_1_initiative = 0
    char_2_initiative = 0
    while (char_1_initiative == char_2_initiative)
        char_1_initiative = char_1.roll_initiative()
        char_2_initiative = char_2.roll_initiative()
    end
    if (char_1_initiative > char_2_initiative)
        first = char_1
        second = char_2
    elsif (char_2_initiative > char_1_initiative)
        first = char_2
        second = char_1
    else
        print("Error in determining initiative order.")
    end
    #if var.verbosity == True: print("{} won the initial initiative roll!".format(attacker.name))
    return first
end


def fight(char_1, monster, turn)
    while true
        if (turn == char_1)
            turn = monster
            # Give character a turn
            if (char_1.hit_points > 0) 
                char_1.take_turn(monster) 
            else
                return "Lose"
            end
        end
        
        if (turn == monster)
            turn = char_1
            # Give goblin a turn
            if (monster.hit_points > 0) 
                monster.take_turn(char_1)
            else
                return "Win"
            end
        end
    end
end



puts
Amber.describe()
Generic_Goblin.describe()

start(Amber, Generic_Goblin)


