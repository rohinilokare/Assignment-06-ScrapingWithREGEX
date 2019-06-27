#!/usr/bin/ruby
require './scraping.rb'
require 'sqlite3'

class ScrapDatabase

    db = SQLite3::Database.open "test.db"
    db.execute "CREATE TABLE IF NOT EXISTS FoodCategory(Id INTEGER PRIMARY KEY,
        CategoryName TEXT, Link VARCHAR)"

    db.execute "INSERT INTO FoodCategory VALUES(1,'Audi','http')"
    db.execute "INSERT INTO FoodCategory VALUES(2,'Mercedes','http')"
    db.execute "INSERT INTO FoodCategory VALUES(3,'Skoda','http')"
    db.execute "INSERT INTO FoodCategory VALUES(4,'Volvo','http')"
    db.execute "INSERT INTO FoodCategory VALUES(5,'Bentley','http')"
    db.execute "INSERT INTO FoodCategory VALUES(6,'Citroen','http')"
    db.execute "INSERT INTO FoodCategory VALUES(7,'Hummer','http')"
    db.execute "INSERT INTO FoodCategory VALUES(8,'Volkswagen','http')"

rescue SQLite3::Exception => e

    puts "Exception occurred"
    puts e

ensure
    db.close if db

end
