require 'thor'
require 'csv'

RECIPE_CSV = 'recipes.csv'

class RecipeList

  def initialize
    @recipes = []
  end

  def add_recipe(recipe)
    @recipes << recipe
  end

  def get_recipe_by_id(recipe_id)
    recipe = @recipes.select { |r| r.id.to_i == recipe_id.to_i }
    raise "Canne find a recipe with id #{recipe_id}" if recipe.empty?
    return recipe.first
  end

  def to_s
    @recipes.map(&:summary).join("\n")
  end

end

class Recipe

  attr_reader :id, :name, :description, :ingredients, :directions

  def initialize(args)
    @id = args[:id]
    @name = args[:name]
    @description = args[:description]
    @ingredients = args[:ingredients]
    @directions = args[:directions]
  end

  def summary
    "#{@id}.  #{@name}"
  end

  def to_s
    str = "#{@id}  -  #{@name}\n"
    str += "#{@description}\n\n"
    str += "Ingredients:\n"
    str += @ingredients.join(', ')
    str += "\n\n"
    str += "Preparation Instructions:\n"
    str += @directions
  end

end

module CSVRecipesHelper

  def self.new_recipe_list_from(csv_file)
    recipe_list = RecipeList.new
    CSV::table(csv_file).each do |recipe_args|
      recipe_args = parse_recipe_args(recipe_args)
      recipe_list.add_recipe(Recipe.new(recipe_args))
    end
    return recipe_list
  end

  private

  def self.parse_recipe_args(args)
    args[:id] = args[:id].to_i
    args[:ingredients] = args[:ingredients].split(', ')
    return args
  end

end

class BerniesBistroApp < Thor

  desc 'list', 'lists all recipes'
  def list
    pre_command
    puts @recipe_list
  end

  desc 'show RECIPE_ID', 'shows the recipe at RECIPE_ID'
  def show(recipe_id)
    pre_command
    puts @recipe_list.get_recipe_by_id(recipe_id)
  end

  private

  def pre_command
    @recipe_list = CSVRecipesHelper::new_recipe_list_from(RECIPE_CSV)
  end

end

BerniesBistroApp.start(ARGV) unless ARGV.empty?
