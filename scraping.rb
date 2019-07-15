require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Scraping

	def initialize()
		@category_object = Nokogiri::HTML(open('https://www.allrecipes.com/').read)
		@category_object = @category_object.to_s
		all_recipes_page_div
	end

	def all_recipes_page_div
		@category_object.scan(/(?m)<div\sid=\"insideScroll\"\sclass=\"grid\sslider\">.*?<\/div>/) do |match|
		@single_div = match.to_s
		end
		category_hash
	end

	def category_href
		@href_array =Array.new
		hrefs = @single_div.scan(/href="(.*?)"/)
		for link in hrefs do
			@href = link[0].to_s
			@href_array.push(@href)
		end
	end

	def category_name
		@category_name_array = Array.new
		category = @single_div.scan(/<span.*>(.*?)<\/span>/)
			for link in category do
				@category = link[0].to_s
				@category_name_array.push(@category)
			end
	end

	def category_hash
		category_href
		category_name
		@category_hash = Hash.new
		cat_name = 0
		@href_array.each do |href|
			@category_hash[@category_name_array[cat_name]] =  href
			cat_name = cat_name +1
		end
		# puts "---------------------------------------------------"
		# puts "@category_hash: #{@category_hash}"
		# puts "---------------------------------------------------"
		category_view_page
	end

	def category_view_page
		@category_viewpage_array = Array.new
		for i in @category_name_array
			html_data =	open(@category_hash[i]).read
			@category_view_object = Nokogiri::HTML(html_data)
			@category_view_object = @category_view_object.to_s
			@category_viewpage_array.push(@category_view_object)
		end
		category_view_div
	end

	def category_view_div
		@category_view__section_array = Array.new
		for view_source_page in @category_viewpage_array
			view_source_page.scan(/(?m)<\s*section\s*id=\"fixedGrid.*>.*?<\s*\/\s*section>/) do |match|
				@section = match.to_s
				@category_view__section_array.push(@section)
			end
		end
		recipes_name
	end


	def recipes_name
		@recipe_name_array = Array.new
		for section in @category_view__section_array
			receipe_names = section.scan(/<span\s*class=\"fixed-recipe-card__title-link\">(.*?)<\/span>/)
			count = 0
			for names in receipe_names do
				@name = names[0].to_s
				if(count <10)
					@recipe_name_array.push(@name)
					count = count +1
				end
			end
		end
		# puts '------------Recipe Names--------------'
		# @recipe_name_array.each_with_index do |value, index|
		# 	puts "#{index}: #{value}"
		# end
		recipes_href
	end

	def recipes_href
		@category_view__div
		@recipe_href_array = Array.new
		for section in @category_view__section_array
			recipe_hrefs = section.scan(/<h3\s*class=\"fixed-recipe-card__h3\">\s*<a\s*href=\"(.*?)\"/)
			count = 0
			for href in recipe_hrefs do
				@hrefs = href[0].to_s
				if(count <10)
				@recipe_href_array.push(@hrefs)
				end
				count = count + 1
			end
		end
		puts '----------Recipe Link------------------'
		@recipe_href_array.each_with_index do |value, index|
			puts "#{index}: #{value}"
			end
		#recipe_hash             //systemStackError ---stack level too deep
		recipe_ingredients_view
	end

	def recipe_hash
		recipes_href
		recipes_name
		@recipe_hash = Hash.new
		recipe_name = 0
		@recipe_href_array.each do |href|
			@recipe_hash[@recipe_name_array[recipe_name]] =  href
			recipe_name = recipe_name +1
		end
		puts "-----------------Recipe Hash----------------------------------"
		@recipe_hash.each do |key, value|
		puts key + ' : ' + value
		end
		puts "---------------------------------------------------"
	end

	def recipe_ingredients_view
		@ingredient_view_page_array =Array.new
		for i in @recipe_href_array
			# puts i
			# puts '-------------'
			html_data1 =open(i).read
			@ingredient_view_page = Nokogiri::HTML(html_data1)
			@ingredient_view_page = @ingredient_view_page.to_s
			@ingredient_view_page_array.push(@ingredient_view_page)
			# if(i == 0)
			# puts '----------'
			# #puts @ingredient_view_page
	  # 	end
		end
		recipe_ingredients_list
	end

	def recipe_ingredients_list
		@ingredients_name_array = Array.new
		for view_page in @ingredient_view_page_array
			@ingredients_names = view_page.scan(/<li\s*class=\"checkList__line\">.*?\s*<label.*?title=\"(.*?)\"/)
			puts @ingredients_names
			for names in @ingredients_names do
				@name = names[0].to_s
				@ingredients_name_array.push(@name)
			end
		end
		puts '----------ingredients List------------------'
		@ingredients_name_array.each_with_index do |value, index|
		puts "#{index}: #{value}"
	end
 end

end

@scraping = Scraping.new

