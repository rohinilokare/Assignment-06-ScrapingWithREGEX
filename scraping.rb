require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Scraping
	#attr_accessor :@category_hash
	def start
		@category_object = Nokogiri::HTML(open('https://www.allrecipes.com/').read)
		@category_object = @category_object.to_s
		div
	end

	def div
		@category_object.scan(/(?m)<div\sid=\"insideScroll\"\sclass=\"grid\sslider\">.*?<\/div>/) do |match|
		@single_div = match.to_s
		@single_div = @single_div.to_s
		puts @single_div
		puts '-----------------------------------------------------------------------------'
		end
		category_hash
	end

	def href
		@href_array =Array.new
		hrefs = @single_div.scan(/href="(.*?)"/)
		#puts "hrefs: #{hrefs}"
		for link in hrefs do
			@href = link[0].to_s
			@href_array.push(@href)
		end
		puts "**************************************************"
		puts "@href_array: #{@href_array}"
		puts "**************************************************"
	end

	def category
		@category_array = Array.new
		category = @single_div.scan(/<span.*>(.*?)<\/span>/)
			for link in category do
				@category = link[0].to_s
				@category_array.push(@category)
			end
		puts "**************************************************"
		puts "@href_array: #{@category_array}"
		puts "**************************************************"
	end

	def category_hash
		href
		category
		@category_hash = Hash.new
		j = 0
	  @href_array.each do |i|
			#puts @category_array[j]
			#puts i
			@category_hash[@category_array[j]] =  i
			j = j+1
		end
		puts @category_hash
		sub_category
	end

def sub_category
			# puts '--------'
			# puts "#{@category_array}"
			@sub_category_array = Array.new
			for i in @category_array
				html_data =	open(@category_hash[i]).read
				@category_object1 = Nokogiri::HTML(html_data)
				@category_object1 = @category_object1.to_s
				@sub_category_array.push(@category_object1)
				#puts @category_object1
			end
			sub_category_div
end

def sub_category_div
		#puts @sub_category_array
		for i in @sub_category_array
				@category_object1.scan(/(?m)<div\sid=\"insideScroll\"\sclass=\"grid\sslider\">.*?<\/div>/) do |match|
		@single_div2 = match.to_s
		@single_div2 = @single_div.to_s
		puts @single_div
		puts '-----------------------------------------------------------------------------'
		end
end
end
@scraping = Scraping.new
@scraping.start
# @scraping.category_hash
#scraping.div

