class Phrases
  DATA = [
    ["the horse and the hound and the horn" ,"that belonged to"],
    ["the farmer sowing his corn" ,"that kept"],
    ["the rooster that crowed in the morn" ,"that woke"],
    ["the priest all shaven and shorn" ,"that married"],
    ["the man all tattered and torn" ,"that kissed"],
    ["the maiden all forlorn" ,"that milked"],
    ["the cow with the crumpled horn" ,"that tossed"],
    ["the dog" ,"that worried"],
    ["the cat" ,"that killed"],
    ["the rat" ,"that ate"],
    ["the malt" ,"that lay in"],
    ["the house" ,"that Jack built"]]

  attr_reader :data

  def initialize(orderer: IdentityOrderer.new)
    @data = orderer.order(DATA)
  end
end

class House
  attr_reader :data, :prefixer

  def initialize(phrases: Phrases.new, prefixer: NormalPrefixer.new)
    @data = phrases.data
    @prefixer = prefixer
  end

  def recite
    1.upto(12).collect {|i| line(i)}.join("\n")
  end

  def line(num)
    "#{prefix} #{phrase(num)}.\n"
  end

  def prefix
    prefixer.prefix
  end

  def phrase(num)
    data.last(num).join(' ')
  end
end

class RandomOrderer
  def order(data)
    data.shuffle
  end
end

class IdentityOrderer
  def order(data)
    data
  end
end

class MostlyRandomOrderer
  def order(data)
    data[0..-2].shuffle << data[-1]
  end
end

class ActorActionMixerOrderer
  def order(data)
    data.transpose.collect {|row| row.shuffle}.transpose
  end
end



class NormalPrefixer
  def prefix
    "This is"
  end
end

class PiratePrefixer
  def prefix
    "Thar be"
  end
end

puts House.new(
  phrases: Phrases.new(orderer: ActorActionMixerOrderer.new),
  prefixer: PiratePrefixer.new).line(12)
