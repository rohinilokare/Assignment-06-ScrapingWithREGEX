require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'

class Scraping
	attr_accessor :category_hash, :recipe_name_array, :recipe_href_array, :ingredients_name_hash

	def initialize
		puts 'initializ'
		@category_object = Nokogiri::HTML(open('https://www.allrecipes.com/').read)
		@category_object = @category_object.to_s
		all_recipes_page_div
	end

	def all_recipes_page_div
		@category_object.scan(/(?m)<div\sid=\"insideScroll\"\sclass=\"grid\sslider\">.*?<\/div>/) do |match|
		@single_div = match.to_s
		end
		category_hash_fun
	end

	def category_name
		@category_name_array = Array.new
		category = @single_div.scan(/<span.*>(.*?)<\/span>/)
			for link in category do
				@category = link[0].to_s
				@category_name_array.push(@category)
			end
	end

	def category_link
		@category_link_array =Array.new
		hrefs = @single_div.scan(/href="(.*?)"/)
		for link in hrefs do
			@href = link[0].to_s
			@category_link_array.push(@href)
		end
	end

	def category_hash_fun
		category_link
		category_name
		@category_hash = Hash.new
		cat_name_index = 0
		@category_link_array.each do |href|
			@category_hash[@category_name_array[cat_name_index]] =  href
			cat_name_index = cat_name_index +1
		end
		 category_view_sourse_page
	end

	def category_view_sourse_page
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
					@recipe_name_array.push(@name.gsub("'",""))
					count = count +1
				end
			end
		end
		recipes_link
	end

	def recipes_link
		@recipe_href_array = Array.new
		for section in @category_view__section_array
			recipe_hrefs = section.scan(/<h3\s*class=\"fixed-recipe-card__h3\">\s*<a\s*href=\"(.*?)\"/)
			count = 0
			for href in recipe_hrefs do
				hrefs = href[0].to_s
				if(count <10)
				@recipe_href_array.push(hrefs)
				end
				count = count + 1
			end
		end
		# puts @recipe_href_array
		# recipe_view_sourse_page
	end

	def recipe_view_sourse_page
		@recipe_view_sourse_page_array =Array.new
		for i in @recipe_href_array
			@ingredient_view_page = Nokogiri::HTML(open(i).read)
			@ingredient_view_page = @ingredient_view_page.to_s
			@recipe_view_sourse_page_array.push(@ingredient_view_page)
		end
		recipe_ingredients_list
	end

	def recipe_ingredients_list
		@ingredients_list_hash = Hash.new
		for view_page in @recipe_view_sourse_page_array
			@ingredients_names = view_page.scan(/<li\s*class=\"checkList__line\">.*?\s*<label.*?title=\"(.*?)\"/)
			ingredients_array = Array.new
			for names in @ingredients_names do
				ingredient = names[0].to_s
				ingredients_array.push(ingredient)
			end
			for recname in @recipe_name_array do
				@ingredients_list_hash[recname] = ingredients_array
			end
		end
		# puts @ingredients_list_hash
		recipe_directions_steps
	end

	def recipe_directions_steps
		@recipe_directions_hash = Hash.new
		for view_page in @recipe_view_sourse_page_array
			@directions_steps = view_page.scan(/<span\s*class=\"recipe-directions__list--item\">(.*?)\s*<\/span>/)
			directions_array = Array.new
			for steps in @directions_steps do
				step = steps[0].to_s
				directions_array.push(step)
			end
			for recname in @recipe_name_array do
				@recipe_directions_hash[recname] = directions_array
			end
		end
		# puts @recipe_directions_hash
		recipe_preparation_time
	end

	def recipe_preparation_time
		@recipe_preparation_time_array = Array.new
		for view_page in @recipe_view_sourse_page_array
			@preparation_times = view_page.scan(/<li\s*class=\"prepTime__item\"\s*aria-label=\"Prep\s*time:(.*?)\"/)
			for times in @preparation_times do
				time = times[0].to_s
				@recipe_preparation_time_array.push(time)
			end
		end
		recipe_cook_time
	end

	def recipe_cook_time
		@recipe_cook_time_array = Array.new
		for view_page in @recipe_view_sourse_page_array
			@cook_times = view_page.scan(/<li\s*class=\"prepTime__item\"\s*aria-label=\"Cook\s*time:(.*?)\"/)
			for times in @cook_times do
				time = times[0].to_s
				@recipe_cook_time_array.push(time)
			end
		end
		recipe_ready_in_time
	end

	def recipe_ready_in_time
		@recipe_ready_in_time_array = Array.new
		for view_page in @recipe_view_sourse_page_array
			@ready_in_times = view_page.scan(/<li\s*class=\"prepTime__item\"\s*aria-label=\"Ready\s*in(.*?)\"/)
			for times in @ready_in_times do
				time = times[0].to_s
				@recipe_ready_in_time_array.push(time)
			end
		end
	end

end

 @scraping = Scraping.new
# scrapdata = ScrapDatabase.new
