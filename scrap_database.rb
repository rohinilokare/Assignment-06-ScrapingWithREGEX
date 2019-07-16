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
		@db = SQLite3::Database.new 'category.db'
		categories_table
	end

	def categories_table
		@db = SQLite3::Database.new 'category.db'
		@db.execute("DROP TABLE IF EXISTS category")
		@db.execute "CREATE TABLE category(Id INTEGER PRIMARY KEY, Name TEXT,  Href TEXT)"

		@scrap.category_hash.each do |key , value|
				@db.execute("INSERT INTO category(Name, Href) VALUES('#{key}',  '#{value}')")
		end
	end

end

db = ScrapDatabase.new
# db.categories_table
