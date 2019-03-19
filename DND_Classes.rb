
require_relative "./DND_Armor.rb"
require_relative "./DND_Weapons.rb"
require_relative "./xdy.rb"

class Character
    #include CreateArmor    # from Objects.rb
    #include CreateWeapons   # from Objects.rb
    include XdY

    attr_reader :name, :race, :level, :proficiency_bonus, :max_HP
    attr_reader :weapon, :armor, :AC
    attr_reader :attack_mod, :attack_bonus, :str, :dex, :con, :str_mod, :dex_mod, :con_mod
    attr_accessor :hit_points


    def initialize(args)
        # initial attributes provided
        @name = args[:name]
        @race = args[:race]
        @str = args[:str]
        @dex = args[:dex]
        @con = args[:con]
        @weapon = args[:weapon]
        @armor = args[:armor]
        @equipment = args[:equipment]
        @features = args[:features]

        # attributes to be determined from initial attributes
        @str_mod = set_ability_modifier(str)
        @dex_mod = set_ability_modifier(dex)
        @con_mod = set_ability_modifier(con)
        @proficiency_bonus = set_proficiency_bonus()
        @attack_mod = set_attack_modifier()
        @attack_bonus = attack_mod + proficiency_bonus
        set_AC()
    end

    # setup methods - used when initializing character ----------------------------------------
    def set_proficiency_bonus()
        if (self.class.superclass == PC)
            level = @level
        elsif (self.class == Monster)
            level = @challenge_rating.to_i
        end
        if (level < 5)
            proficiency_bonus = 2
        elsif (level < 9)
            proficiency_bonus = 3
        elsif (level < 13)
            proficiency_bonus = 4
        elsif (level < 17)
            proficiency_bonus = 5
        else
            proficiency_bonus = 6
        end
        return proficiency_bonus
    end

    def set_ability_modifier(ability_score)
        ability_mod = (ability_score - 10)/2
        return (ability_mod).floor
    end

    def set_AC
        @AC = armor.base_AC + [dex_mod, armor.max_dex_bonus].min
    end

    def set_attack_modifier
        if weapon.properties().include?("Finesse")
            attack_mod = [str_mod, dex_mod].max
        else
            attack_mod = str_mod
        end
        return attack_mod
    end

    def set_HP_to_max
        @hit_points = max_HP
    end


    # miscellaneous methods -------------------------------------------------
    def describe()
        puts
        puts "************************************************"
        puts "Name: #{name}"
        puts "Race: #{race}"
        if (self.class==Monster)
            puts "Class: Monster {Challenge Rating #{challenge_rating})"
        elsif (self.class.superclass == PC)
            puts "Class: #{character_class} {Level #{level})"
        end
        puts "Max HP: #{max_HP}"
        puts "Proficiency Bonus: +#{proficiency_bonus}"
        puts "AC: #{self.AC}  (Armor: #{armor.name()})"
        puts "Weapon: #{weapon.name()}"
        puts "Str: #{str}   Str Mod: +#{str_mod}"
        puts "Dex: #{dex}   Dex Mod: +#{dex_mod}"
        puts "Con: #{con}   Con Mod: +#{con_mod}"
        puts "Attack modifier: +#{attack_mod}"
        puts "************************************************"

    end


    # Character methods - stuff they can do ----------------------------------------------
    def roll_initiative()
        roll = xdy('1d20')
        puts "#{name} rolls a #{roll+dex_mod} (#{roll}+#{dex_mod}) for initiative."
        return roll + dex_mod
    end

    def take_turn(target)
        if target.hit_points > 0
            (0...@attacks).each do
                puts "#{self.name} attacks #{target.name}!"
                attack(target)
            end
        end
    end

    def attack(target)
        attack_roll = xdy("1d20")
        attack_score = attack_roll + attack_bonus

        if (attack_roll == 20)
            puts "#{name} rolls a natural 20, scoring a critical hit."
            damage = calculate_damage(crit=true)
        elsif (attack_roll == 1)
            puts "#{name} rolls a natural 1, scoring a critical miss."
            damage = 0
        elsif (attack_score >= target.AC)
            puts "#{name} rolls #{attack_score} (#{attack_roll}+#{attack_bonus}) against an AC of #{target.AC}, and hits."
            damage = calculate_damage(crit=false)
        else
            puts "#{name} rolls #{attack_score} (#{attack_roll}+#{attack_bonus}) against an AC of #{target.AC}, and misses."
            damage = 0
        end
        target.take_damage(damage)
    end

    def calculate_damage(crit)
        #@weapon.damage.each |type, damage| # requires weapon.damage to be a {type: damage} hash, allows multiple damage types per attack
        damage_roll = xdy(weapon.damage)
        if crit then 
            damage_roll_2 = xdy(weapon.damage) 
            damage_roll += damage_roll_2
        end
        damage_bonus = attack_mod
        damage_total = damage_roll + damage_bonus
        if crit then 
            puts "#{name} does #{damage_total} ((#{damage_roll-damage_roll_2})+#{damage_roll_2})+#{damage_bonus}) #{weapon.type.downcase} damage."
        else
            puts "#{name} does #{damage_total} (#{damage_roll}+#{damage_bonus}) #{weapon.type.downcase} damage."
        end
        return [damage_total, weapon.type]
    end

    def take_damage(damage)
        type = damage[1]
        self.hit_points -= damage[0]
        if self.hit_points < 0
            self.hit_points = 0
        end
    end

end



class PC < Character
    attr_reader :character_class, :level

    def initialize(args)
        @level = args[:level]
        super(args)
    end
end



class Fighter < PC
    attr_reader :con_mod, :attacks, :max_HP, :level
    attr_accessor :hit_points

    def initialize(args)
        super(args)
        @character_class = "Fighter"
        @max_HP = set_max_HP()
        set_HP_to_max() # method in Character
        set_attacks()
        if (@level >= 2)
            features.push("Action Surge")
        end
    end

    def set_max_HP()
        max_HP = 10 + con_mod
        max_HP += (level - 1)*(xdy("1d10") + con_mod)
    end

    def set_attacks()
        case @level
        when 1..4 then @attacks = 1
        when 5..10 then @attacks = 2
        when 11..19 then @attacks = 3
        when 20 then @attacks = 4
        else puts "Error calculating attacks, level #{level} shouldn't be possible."
        end
    end
end



class Monster < Character
    include XdY
    attr_reader :hit_dice, :max_HP, :hit_points, :challenge_rating
    attr_accessor :hit_points

    def initialize(args)
        @hit_dice = args[:hit_dice] # unique to monsters, not used by PCs
        @challenge_rating = args[:CR]
        @attacks = args[:attacks]
        set_max_HP()
        set_HP_to_max() # method in Character
        super(args)
    end

    def set_max_HP
        @max_HP = xdy(hit_dice)
    end
end










