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
		@db.execute "CREATE TABLE category_table(Id INTEGER PRIMARY KEY, Name TEXT,  Href TEXT)"
		@scrap.category_hash.each do |key , value|
				@db.execute("INSERT INTO category_table(Name, Href) VALUES('#{key}',  '#{value}')")
		end
		 recipes_table
		#recipe_ingredients_table
	end

 	def recipes_table
		@db.execute("DROP TABLE IF EXISTS recipes")
		@db.execute "CREATE TABLE recipes(Id INTEGER PRIMARY KEY, RecipeName TEXT)"
		@scrap.recipe_name_array.each do |recipe_name|
			@db.execute("INSERT INTO recipes(RecipeName) VALUES('#{recipe_name}');")
		end
	end

	def recipe_ingredients_table
		# @db = SQLite3::Database.new 'ingredients.db'
		@db.execute("DROP TABLE IF EXISTS recipe_ingredients")
		@db.execute "CREATE TABLE recipe_ingredients(Id INTEGER PRIMARY KEY, recipeName TEXT,  ingredients BLOB)"
		@scrap.ingredients_name_hash.each do |key , value|
			@db.execute("INSERT INTO recipe_ingredients(recipeName, ingredients) VALUES('#{key}',  '#{value}')")
		end
	end

end

db = ScrapDatabase.new
# db.categories_table
