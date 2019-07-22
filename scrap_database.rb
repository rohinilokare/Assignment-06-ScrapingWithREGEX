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
		@db = SQLite3::Database.new 'AllRecipes.db'
		categories_table
	end

	def categories_table
		@db.execute("DROP TABLE IF EXISTS category_table")
		@db.execute "CREATE TABLE category_table(Id INTEGER PRIMARY KEY, CategoryName TEXT,  CategoryLink TEXT)"
		@scrap.category_hash.each do |key , value|
				@db.execute("INSERT INTO category_table(CategoryName, CategoryLink) VALUES('#{key}',  '#{value}')")
		end
		 recipes_table
		#recipe_ingredients_table
	end

 	def recipes_table
		@db.execute("DROP TABLE IF EXISTS recipes")
		@db.execute "CREATE TABLE recipes(Id INTEGER PRIMARY KEY, RecipeName TEXT,RecipeLink TEXT,Ingredients array)"
		@scrap.recipe_name_array.each do |recipe_name|
			@db.execute("INSERT INTO recipes(RecipeName) VALUES('#{recipe_name}');")
		end
		add_recipe_link
	end

	def add_recipe_link
		puts '---------in add recipe------------'
		id = 1
		@scrap.recipe_href_array.each do |recipe_link |
			@db.execute("UPDATE recipes SET RecipeLink = '#{recipe_link}' WHERE Id='#{id}';")
			id = id +1
		end
		#recipe_ingredients_table
	end


	# def add_recipe_link
	# 		puts '---------in add recipe------------'
	# 		@db.execute("UPDATE recipes SET RecipeLink = 'lokare.rohini' WHERE Id='1';")
	# 	# end
	# 	# add_recipe_prep_time
	# end

	def recipe_ingredients_table
		puts '---------in ingredients recipe------------'
		id = 1
		@scrap.ingredients_list_array.each do |recipe_ingredients |
			@db.execute("UPDATE recipes SET Ingredients = '#{recipe_ingredients}' WHERE Id='#{id}';")
			id = id +1
		end
	end

end

db = ScrapDatabase.new
# db.categories_table
