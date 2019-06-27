require 'rubygems'
require 'nokogiri'
require 'open-uri'


class Scraping

	def initialize()
		@category_object = Nokogiri::HTML(open('https://www.allrecipes.com/').read)
		@category_object = @category_object.to_s
		all_receipe_div
	end

	def all_receipe_div
		@category_object.scan(/(?m)<div\sid=\"insideScroll\"\sclass=\"grid\sslider\">.*?<\/div>/) do |match|
		@single_div = match.to_s
		@single_div = @single_div.to_s
		puts @single_div
		puts '-----------------------------------------------------------------------------'
		end
		category_hash
	end

	def category_href
		@href_array =Array.new
		hrefs = @single_div.scan(/href="(.*?)"/)
		#puts "hrefs: #{hrefs}"
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
		sub_category
	end

def sub_category
			@sub_category_viewpage_array = Array.new
			for i in @category_name_array
				#puts @category_hash[i]
				html_data =	open(@category_hash[i]).read
				@category_object1 = Nokogiri::HTML(html_data)
				@category_object1 = @category_object1.to_s
				@sub_category_viewpage_array.push(@category_object1)
			end
			#puts @sub_category_viewpage_array
			sub_category_div
end

def sub_category_div
		@sub_category_section_array = Array.new
		for view_source_page in @sub_category_viewpage_array
				view_source_page.scan(/(?m)<\s*section\s*id=\"fixedGrid.*>.*?<\s*\/\s*section>/) do |match|
					@section = match.to_s
					@sub_category_section_array.push(@section)
					#puts "@category_section: #{@section}"
					puts '-----------------------------------------------------------------------------'
				end
		end
end


def sub_category_name
			for section in sub_category_section_array
				subcategory_name = section.scan()
			end
end
end

@scraping = Scraping.new

