###############################
# a bit of simple math
###############################
1 + 2           # => 3

# what is it?
1.class         # +> Integer

# what does it know?
Integer.instance_methods
Integer.instance_methods.class               # => Array
Integer.instance_methods.sort
Integer.instance_methods.size

Integer.superclass
Integer.ancestors
Integer.instance_methods(false).size
Integer.instance_methods(false).sort
Integer.instance_methods(false).sort[4]       # +> :+
Integer.instance_methods(false).sort[4].class # +> Symbol
#  http://ruby-doc.org/core-2.0.0/Symbol.html



###############################
# 1 + 2 is syntactic sugar
###############################
1 + 2                       # => 3
1 +(2)                      # => 3, parens are optional
1.+(2)                      # => 3, the '.' was inferred

1.send(:+, 2)               # => 3, the symbol represents a message

message = '+'
1.send(message.to_sym, 2)  # => 3, sending a dynamically constructed message

1.public_send(:+, 2)       # => 3, only sending if it's public



###############################
# a simple equality comparison
###############################
1 == 2

# what is it?
(1 == 2).class

# what does it know?
FalseClass.instance_methods
FalseClass.instance_methods.sort
FalseClass.instance_methods.size

FalseClass.superclass
FalseClass.instance_methods(false).size
FalseClass.instance_methods(false).sort

# Look at the source for FalseClass #&
#   http://ruby-doc.org/core-2.0.0/FalseClass.html

nil.class
# Look at the source for NilClass #&
#   http://ruby-doc.org/core-2.0.0/NilClass.html

# Integers, Symbols, true, false, and nil are 'immediate' objects.
