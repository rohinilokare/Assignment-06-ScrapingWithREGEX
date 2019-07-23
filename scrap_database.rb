#!/usr/bin/ruby
require './scraping.rb'
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
		@db.execute "CREATE TABLE recipes(Id INTEGER PRIMARY KEY, RecipeName TEXT,RecipeLink TEXT,PraparationTime TEXT,CookTime TEXT,ReadyIn TEXT,CategoryID INTEGER,FOREIGN KEY(CategoryID) REFERENCES category_table(id))"
		@scrap.recipe_name_array.each do |recipe_name|
			@db.execute("INSERT INTO recipes(RecipeName) VALUES('#{recipe_name}');")
		end
		add_category_id
	end

	def add_category_id
		puts 'Inserting category id into recipe table'
		count = 1
		id = 1
		@scrap.recipe_name_array.each do |r_name |
			if(count == 10)
				count = 1
			end
				@db.execute("UPDATE recipes SET CategoryID = '#{id}';")
				count = count + 1
				if(count == 10)
					id = id + 1
				end
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
		recipe_ingredients
	end

	def recipe_ingredients
		puts 'Creating Recipe Ingredients Table'
		@db.execute("DROP TABLE IF EXISTS RecipeIngredients")
		@db.execute "CREATE TABLE RecipeIngredients(Id INTEGER PRIMARY KEY, Ingredients TEXT,RecipeId INTEGER,FOREIGN KEY(RecipeId) REFERENCES recipes(id))"
		id = 1
		@scrap.ingredients_list_array.each do |ingredients |
			ingredients.each do |ingrgredient |
			@db.execute("INSERT INTO RecipeIngredients(Ingredients,RecipeId) VALUES('#{ingrgredient}','#{id}');")
			end
			id = id +1
		end
		 recipe_directions
	end

	def recipe_directions
		puts 'Creating Recipe Directions Table'
		@db.execute("DROP TABLE IF EXISTS RecipeDirections")
		@db.execute "CREATE TABLE RecipeDirections(Id INTEGER PRIMARY KEY, Directions TEXT,RecipeId INTEGER,FOREIGN KEY(RecipeId) REFERENCES recipes(id))"
		id = 1
		@scrap.recipe_directions_array.each do |directions |
						directions.each do |direction |
			@db.execute("INSERT INTO RecipeDirections(Directions,RecipeId) VALUES('#{direction}','#{id}');")
			end
			id = id +1
		end
	end

end

db = ScrapDatabase.new

