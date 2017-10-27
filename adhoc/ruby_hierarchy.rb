####################
# Exploring the Ruby Object Hierarchy
####################
1.class       # => Integer
Integer.class # => Class


# what are the classes of all of my ancestors?
Integer.ancestors.collect {|ancestor| "(#{ancestor.class}) #{ancestor}"}

# what is this module thing?
Module.class # => Class

Class.superclass  # => Module
Module.superclass # => Object
# Therefore: Class is a Module is an Object


# Re-open the Class class and define a new method.
class Class
  def subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end

# Now I can send #subclasses to any instance of Class
Integer.ancestors   # look upwards
Integer.subclasses  # look downwards
Numeric.subclasses  #         "

# The current #subclasses method shows every decendant of a Class,
# i.e. Numeric has subclass Integer, which has subclasses Bignum and Fixnum.
# It shows everthing in the hierarchy below the starting class.

# What if I want to see a nested hierarchy?
class Class

  # find immediate subclasses only
  def subclasses(parent=self)
    ObjectSpace.each_object(Class).select { |klass| klass.superclass == parent }
  end

  # find decendant subclass
  def decendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  # recurse down the hiearchy
  def nested_subclasses(parent=self)
    subclasses(parent).collect {|subclass|
      {subclass => nested_subclasses(subclass)}
    }
  end
end

Integer.subclasses           # => []

Numeric.subclasses          # => [Complex, Rational, Float, Integer]
Numeric.decendants          # => [Complex, Rational, Float, Integer]

Object.subclasses
Object.decendants
Object.nested_subclasses   # correct result, but it's ugly

class Class

  def nested_subclasses(parent=self)
    subclasses(parent).collect {|subclass|
      next_level_subclasses = nested_subclasses(subclass)

      if next_level_subclasses.empty?
        subclass
      else
        {subclass => next_level_subclasses}
      end
    }
  end

end

Numeric.nested_subclasses
Object.nested_subclasses
Exception.nested_subclasses

# Bonus: What happens is you send #subclasses to an instance of Module?
#        How would you fix this?
Comparable.class        # => Module
Comparable.subclasses
# => NoMethodError: undefined method `subclasses' for Comparable:Module
