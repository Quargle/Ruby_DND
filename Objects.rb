
module CreateArmor
    Unarmored = Armor.new(:name => "no armor", :base_AC => 10, :type => "Light")
    Leather = Armor.new(:name => "Leather", :base_AC => 11, :type => "Light")
    Studded_Leather = Armor.new(:name => "Studded", :base_AC => 12, :type => "Light")
    Hide = Armor.new(:name => "Hide", :base_AC => 12, :type => "Medium")
    Chain_Shirt = Armor.new(:name => "Chain_Shirt", :base_AC => 13, :type => "Medium")
    Scale_Mail = Armor.new(:name => "Scale_Mail", :base_AC => 14, :type => "Medium")
    Breastplate = Armor.new(:name => "Breastplate", :base_AC => 14, :type => "Medium")
    Half_Plate = Armor.new(:name => "Half_Plate", :base_AC => 15, :type => "Medium")
    Chainmail = Armor.new(:name => "Chainmail", :base_AC => 16, :type => "Heavy")
    Splint = Armor.new(:name => "Splint", :base_AC => 17, :type => "Heavy")
    Full_Plate = Armor.new(:name => "Full_Plate", :base_AC => 18, :type => "Heavy")
    Integrated_Heavy_Plating = Armor.new(:name => "Integrated_Heavy_Plating", :base_AC => 16, :type => "Heavy")
end


module CreateWeapons
    Unarmed_Strike = Weapon.new(:name => "Unarmed_Strike", :damage => "1d4", :type => "Bludgeoning", :properties => ["Unarmed"])
    Quarterstaff = Weapon.new(:name => "Quarterstaff", :damage => "1d8", :type => "Bludgeoning", :properties => ["Versatile"])
    Shortsword = Weapon.new(:name => "Shortsword", :damage => "1d6", :type => "Piercing", :properties => ["Finesse", "Light"])
    Rapier = Weapon.new(:name => "Rapier", :damage => "1d8", :type => "Piercing", :properties => ["Finesse"])
    Flail = Weapon.new(:name => "Flail", :damage => "1d8", :type => "Bludgeoning", :properties => [])
    Battleaxe = Weapon.new(:name => "Battleaxe", :damage => "1d8", :type => "Slashing", :properties => ["Versatile"])
    Longsword = Weapon.new(:name => "Longsword", :damage => "1d8", :type => "Slashing", :properties => ["Versatile"])
    Greatsword = Weapon.new(:name => "Greatsword", :damage => "2d6", :type => "Slashing", :properties => ["2-handed"])
    Maul = Weapon.new(:name => "Maul", :damage => "2d6", :type => "Bludgeoning", :properties => ["2-handed"])
    Greataxe = Weapon.new(:name => "Greataxe", :damage => "1d12", :type => "Slashing", :properties => ["2-handed"])
    Scimitar = Weapon.new(:name => "Scimitar", :damage => "1d6", :type => "Slashing", :properties => ["Finesse"])
end