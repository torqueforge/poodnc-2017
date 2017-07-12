using Article

class Farm
  attr_reader :animals

  def initialize(animals)
    @animals = animals
  end

  def lyrics
    animals.collect {|animal| verse(animal) }.join("\n\n")
  end

  def verse(animal)
    sound   = animal.sound
    species = animal.species

    "Old MacDonald had a farm, E-I-E-I-O,\n" +
    "And on that farm he had #{species.articlize}, E-I-E-I-O,\n" +
    "With #{sound.articlize} #{sound} here " +
      "and #{sound.articlize} #{sound} there,\n" +
    "Here #{sound.articlize}, there #{sound.articlize}, " +
      "everywhere #{sound.articlize} #{sound},\n" +
    "Old MacDonald had a farm, E-I-E-I-O."
  end
end

class NullAnimal
  def sound
    "<silence>"
  end

  def species
    "<silence>"
  end
end

class MyAnimal
  def self.all(ids)
    Animal.all(ids).collect {|animal| animal || NullAnimal.new}
  end
end


# The following ensures that my wrapper is called instead of original method
require 'pathname'
module Animal
  singleton_class.send(:alias_method, :orig_all, :all)

  def self.all(ids)
    validate_caller(caller_locations(1,1).first)
    orig_all(ids)
  end

  def self.validate_caller(caller)
    actual_calling_file = Pathname.new(caller.path).basename.to_s
    expected_calling_file = "farm.rb"

    msg = "Animal.all may only be called by MyAnimal (defined in #{expected_calling_file})." +
          "Please change 'Anmial.all' to 'MyAnimal.all' in #{actual_calling_file}) "

    raise "Error: #{msg}" unless actual_calling_file == expected_calling_file
  end
end
