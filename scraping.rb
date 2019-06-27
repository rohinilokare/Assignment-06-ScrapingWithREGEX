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
		@single_div = @single_div.to_s
		#puts @single_div
		#puts '-----------------------------------------------------------------------------'
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
		# puts "**************************************************"
		# puts "@href_array: #{@href_array}"
		# puts "**************************************************"
	end

	def category_name
		@category_name_array = Array.new
		category = @single_div.scan(/<span.*>(.*?)<\/span>/)
			for link in category do
				@category = link[0].to_s
				@category_name_array.push(@category)
			end
		# puts "**************************************************"
		# puts "@category_name: #{@category_name_array}"
		# puts "**************************************************"
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
		puts "**************************************************"
		puts "@category_hash: #{@category_hash}"
		puts "**************************************************"
		category_view_page
	end

	def category_view_page
		@sub_category_viewpage_array = Array.new
		for i in @category_name_array
			html_data =	open(@category_hash[i]).read
			@category_view_object = Nokogiri::HTML(html_data)
			@category_view_object = @category_view_object.to_s
			@sub_category_viewpage_array.push(@category_view_object)
		end
		category_view_div
	end

	def category_view_div
		@category_view__section_array = Array.new
		for view_source_page in @sub_category_viewpage_array
			view_source_page.scan(/<span\s*class=\"fixed-recipe-card__title-link\">(.*?)<\/span>/) do |match|
				@recipename = match.to_s
				@category_view__section_array.push(@recipename)
				puts "@recipe name: #{@recipename}"
				puts '-----------------------------------------------------------------------------'
			end
		end
	end


	def recipes_name
		@recipe_name_array = Array.new
			for section in @category_view__section_array
				receipe_names = section.scan(/<span\s*class=\"fixed-recipe-card__title-link\">(.*?)<\/span>/)
				for names in receipe_names do
					@name = names[0].to_s
					@recipe_name_array.push(@name)
				end
			end
	end

	def recipe_href
		@recipe_name_array = Array.new
		for section in @category_view__section_array
			receipe_names = section.scan(/href="(.*?)"/)
			for names in receipe_names do
				@name = names[0].to_s
				@recipe_name_array.push(@name)
			end
		end
	end


end

@scraping = Scraping.new

