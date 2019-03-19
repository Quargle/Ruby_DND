

module Create_Characters

    require_relative "./DND_Classes.rb"
    require_relative "./Objects.rb"

    include CreateArmor
    include CreateWeapons

    Amber = Fighter.new(
        :name => "Amber",
        :race => "Mountain Dwarf",
        :level => 1,
        :str => 17,
        :dex => 12,
        :con => 16,
        :weapon =>  Maul,
        :armor => Chainmail,
        :equipment => [],
        :features => ["Great Weapon Fighting"]
    )

    Generic_Goblin = Monster.new(
        :name => "The Goblin",
        :race => "Goblin",
        :hit_dice => "2d6",
        :CR => "1/4",
        :str => 8,
        :dex => 14,
        :con => 10,
        :weapon => Scimitar,
        :armor => Leather,
        :equipment => ["Shield"],
        :features => ["Nimble Escape"],
        :attacks => 1
    )

    Baz = Fighter.new(
        :name => "Baz",
        :race => "Mountain Dwarf",
        :level => 1,
        :str => 18,
        :dex => 12,
        :con => 16,
        :weapon =>  Battleaxe,
        :armor => Chainmail,
        :equipment => ["Shield"],
        :features => ["Great Weapon Fighting"]
        )


end
