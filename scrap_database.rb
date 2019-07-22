#!/usr/bin/ruby
require '/home/rohini/Git/Project/Assignment-06-ScrapingWithREGEX/scraping.rb'
require 'sqlite3'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

class ScrapDatabase
	attr_accessor :scrap

	def initialize
		@scrap = Scraping.new
		puts 'Creating Database AllRecipes.db'
		@db = SQLite3::Database.new 'AllRecipes.db'
		categories_table
	end

	def categories_table
		puts 'Creating Category Table'
		@db.execute("DROP TABLE IF EXISTS category_table")
		@db.execute "CREATE TABLE category_table(Id INTEGER PRIMARY KEY, CategoryName TEXT,  CategoryLink TEXT)"
		@scrap.category_hash.each do |key , value|
				@db.execute("INSERT INTO category_table(CategoryName, CategoryLink) VALUES('#{key}',  '#{value}')")
		end
		 recipes_table
	end

 	def recipes_table
 		puts 'Creating Recipe Table'
 		puts 'Inserting recipe name with primary key ID'
		@db.execute("DROP TABLE IF EXISTS recipes")
		@db.execute "CREATE TABLE recipes(Id INTEGER PRIMARY KEY, RecipeName TEXT,RecipeLink TEXT,PraparationTime TEXT,CookTime TEXT,ReadyIn TEXT,Ingredients array ,Directions array)"
		@scrap.recipe_name_array.each do |recipe_name|
			@db.execute("INSERT INTO recipes(RecipeName) VALUES('#{recipe_name}');")
		end
		add_recipe_link
	end

	def add_recipe_link
		puts 'Inserting Recipe Link into recipe table'
		id = 1
		@scrap.recipe_href_array.each do |recipe_link |
			@db.execute("UPDATE recipes SET RecipeLink = '#{recipe_link}' WHERE Id='#{id}';")
			id = id +1
		end
		add_preparation_time
	end

	def add_preparation_time
		puts 'Inserting Recipe preparation_time into recipe table'
		id = 1
		@scrap.recipe_preparation_time_array.each do |preparation_time |
			@db.execute("UPDATE recipes SET PraparationTime = '#{preparation_time}' WHERE Id='#{id}';")
			id = id +1
		end
		add_cook_time
	end

	def add_cook_time
		puts 'Inserting Recipe cook_time into recipe table'
		id = 1
		@scrap.recipe_cook_time_array.each do |cook_time |
			@db.execute("UPDATE recipes SET CookTime = '#{cook_time}' WHERE Id='#{id}';")
			id = id +1
		end
		add_ready_in_time
	end

	def add_ready_in_time
		puts 'Inserting Recipe ready_in_time into recipe table'
		id = 1
		@scrap.recipe_ready_in_time_array.each do |ready_in_time |
			@db.execute("UPDATE recipes SET ReadyIn = '#{ready_in_time}' WHERE Id='#{id}';")
			id = id +1
		end
		add_recipe_ingredients
	end

	def add_recipe_ingredients
		puts 'Inserting Recipe ingredients into recipe table'
		id = 1
		@scrap.ingredients_list_array.each do |ingredients |
			@db.execute("UPDATE recipes SET Ingredients = '#{ingredients.to_s}' WHERE Id='#{id}';")
			id = id +1
		end
		 add_recipe_directions
	end

	def add_recipe_directions
		puts 'Inserting Recipe directions into recipe table'
		id = 1
		@scrap.recipe_directions_array.each do |directions |
			@db.execute("UPDATE recipes SET Directions = '#{directions}' WHERE Id='#{id}';")
			id = id +1
		end
	end

end

db = ScrapDatabase.new
# db.categories_table
