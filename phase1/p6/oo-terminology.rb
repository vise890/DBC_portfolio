# attr_reader
#   creates a reader (getter) method
#   for the instance variable names
#   specified as "arguments"
#
#   getter methods are used to access
#   the value of instance variables from
#   outside the class. They are part of
#   the public interface of a class.
#

# attr_writer
#   creates a writer (setter) method
#   for the instance variable names
#   specified as "arguments"
#
#   setter methods allow to change the value
#   of the instance variable from outside the
#   class. They are part of the class' public
#   interface of the class.
#

# attr_accessor
#   creates both writer and reader methods
#   for the variable names specified as arguments
#   (basically attr_reader + attr_writer combined)
#

class Chef

  attr_accessor :pudginess
  # ^ same as writing:
  # attr_reader :pudginess
  # attr_writer :pudginess

  def initialize(args)
    @stomach = []
    @pudginess = args[:pudginess] || :low
  end

  # attr_reader :pudginess makes the code
  # below rendundant (it creates the same mehtod)
  #
  # returns the value of the @pudginess attribute
  def pudginess
    @pudginess
  end

  # attr_writer :pudginess makes the code
  # below rendundant (it creates the same mehtod)
  #
  # allows for the @pudginess attribute to be set
  # to new_pudginess_value
  def pudginess=(new_pudginess_value)
    @pudginess = new_pudginess_value
  end

  def eat(food)
    @stomach << food
    @pudginess = :moderate if @stomach.size > 5
  end

end


#################################################
#################################################

# Public methods
#   defined inside the scope of a class, before
#   the keyword "private" (or "protected")
#
#   they are accessible from outside the class
#   they form the public interface of the instances
#   of that class

# Private methods
#   defined inside the scope of a class, but after
#   the "private" keyword.
#
#   they are *not* accessible from outside the class
#     (but can still be accessed with #send...)
#   they are *not* part of the public interface
#   they are usually utility methods/deal with the
#   inner workings of the class

# ...reopening Chef (monkey patching the thing?)
class Chef

  def cook(food)
    food.cook
    food.season_with(secret_spice)
  end

  private

  def secret_spice
    [:saffron, :nutmeg, :mustard, :turmeric, :ginger, :cinnamon].sample
  end

end
# here the cook method is part of the public interface of
# Chef objects:
c = Chef.new
c.cook(spaghetti_alla_carbonara)
# however, if we try steal one of the Coook's secret spices:
# secret_spice = c.secret_spice
# .. we will get an error (NoMethodError)
# because the secret_spice method is private (it's not
# meant to be accessed from outside)
#
# we can still be sneaky and access it with send though:
secret_spice = c.send(:secret_spice)
# ^ that'd work

##################################################
##################################################

# Instance variables
#   every _instance_ of a particular class
#   will have its own instance variable
#
#   they are attributes of the single objects, like
#   the level of pudginess of a Chef
#
#   can be read and/or written with attr_reader,
#   attr_writer and attr_accessor

# Class variables
#   act like global variables, except that their scope
#   is limited to that class. Therefore, they can be
#   accessed (and modified) by instances of the class,
#   class definition etc.
#
#   Once changed, the class variable is changed for all
#   instances of the class and all its subclasses (and
#   superclasses, depending on where the class var is
#   defined)

class Food

  @@foods_made = 0

  attr_reader :name, :ingredients
  def initialize(args)
    @name = args[:name]
    @ingredients = args[:ingredients]
    @@foods_made += 1
  end

  def foods_made
    @@foods_made
  end

end

spaghettios = Food.new(name: 'spaghettios', ingredients: ['sauce', 'spaghettios'])
duck = Food.new(name: 'hosin duck', ingredients: ['duck', 'hoisin sauce', 'pancakes'])

# Instance variables
# we can access the instance variables of the objects spaghettios and duck
# through the getters that attr_reader has made
spaghettios.name #=> 'spaghettios'
duck.name #=> 'hoisin duck'
# .. every instance has its own name

# Class variables
spaghettios.foods_made #=> 2
duck.foods_made #=> 2
# the instance method `foods_made` allows us to access the @@foods_made class
# variable, which is incremented every time the class is instantiated
# therefore, if we want to know how many Foods we have made, we can just call
# it
#
# note that every instance accesses the same variable (they all point to the same thing)

###################################################
###################################################

# Class Methods
#   are defined inside a class with def self.method_name
#   (or def ClassName.method_name)
#
#   can be called directly on the class
#   (ClassName.method_name)
#
#   should refer to thigs that the class should know
#   what to do, not the single instance of it
#   (examples below)
#

# Instance Methods
#   are defined with def method_name
#
#   can be called on the instances of the class
#
#   should do things that a single instance should know
#   what to do
#

class Food

  def self.number_of_foods_made
    @@foods_made
  end

  def self.new_food_from_str(str)
    name = '' # e.g. RegEx match
    ingredients = [] # ...
    self.new({ name: name, ingredients: ingredients })
  end

  def delicious?
    [true,true,true,true,false].sample
  end

end
# in the above, we made the number_of_foods_made a class method
# we can now call it like this
Food.number_of_foods_made #=> 2
# a class method is a better solution for this sort of functionality
# because a single food object (like the spaghettios) should not
# know how many other foods are out there..

# the new_food_from_str takes a str and makes a new Food object
# (well almost). Spaghettios should not know how to make tofu,
# Food should (arguably)
Food.new_food_from_str('Tofu | tofu, chili, chives, soy sauce')

# the delicious method, on the other hand, is an instance method.
# it returns true or false for that instance. duck should be delicious or
# not. But the Food "mould" should not.
duck.delicious?

###################################################
###################################################

module Bakable

  def bake!
    @status = [:burned, :fragrant, :crispy].sample
  end

end

module Steamable

  def steam!
    @status = [:steamy, :scalding_hot, :moist].sample
  end

end

# I want foods that behave as bakable goods. I don't really care
# if they're bread, cookies or bruschette. they're all bakable
# and they should all have a bake! method
# so i could do things like this:
class Bread
  include Bakable
end

class Brownies
  include Bakable
end

class Broccoli
  include Steamable
end

bread = Bread.new.bake!
bread.status #=> :burned || :crispy
brownies = Brownies.new.bake!
brownies.status #=> :burned || :crispy
broccoli = Broccoli.new.steam!
broccoli.status #=> :steamy || :moist etc.

# in this case, Brownies are not a kind of bread,
# and bread is not a kind of brownie. I can just add
# the bakable behaviour to anything I like.
#
# I would have used Inheritance if I was modelling things
# that were kinds of each other. for example, if I wanted
# to model different Breads, I could have a Bread class (perhaps
# with Bakable mixed in) and a Ciabatta < Bread subclass.
# that inherited all the attributes and Behaviour of a Bread

###################################################
###################################################
###################################################
###################################################
###################################################
###################################################
# PART 2

# 1. Reducing dependencies
# Before
class Kitchen

  def initialize
    @pending_orders = []
  end

  def new_order(food_args, table)
    @pending_orders << Order.new(Food.new(food_args), table)
  end
end
# the kitchen class knows way too much:
#   - an Order class exists
#   - it takes a Food and a table as args, in that order
#   - a Food class exists
#   - it takes food_args as an argument

# After
# dependency injection to the rescue...
class Kitchen

  def initialize
    @pending_orders = []
  end

  def new_order(order)
    @pending_orders << order
  end

end

class Order

  def initialize(food, table)
    @food = food
    @table = table
  end

end

class Food
  ...
end

# 2.What Vs. How
# before
class Chef

  def cook(food)
    food.status = :cooked
    food.edible = :true
    food.crispiness = 132
    food.spices << :saffron
    food.spices << :pepper
  end

end
# here the #cook method knows how to cook the
# food. it knows its attributes very intimately: it knows what they
# are and how they are supposed to look when the food is
# cooked
#

# after
class Chef

  def cook(food)
    food.cook!
    food.season_with([:saffron, :pepper])
  end

end
# this version is much less tightly coupled with the inner
# workings of the food. We're just telling it too cook itself
# and to season itself with saffron and pepper. Instead of telling it
# *how* to cook itself, and *how* to add spices.
# note we also reduced the dependency on the data structure of spices
