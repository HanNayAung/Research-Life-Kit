#!/usr/bin/ruby

# Need to Install 'watir' , 'webdrivers', 'nokogiri' gems
# sudo gem install webdrivers

require_relative "research_life_kit/version"
require 'watir'
require 'webdrivers'
require 'nokogiri'


# module ResearchLifeKit
#   class Error < StandardError; end
#   # Your code goes here...
#   puts "hello"
# end


# require 'net/http'
# Net::HTTP.start('www.rubyinside.com') do |http|
#   req = Net::HTTP::Get.new('/test.txt')
#   puts http.request(req).body
# end

# require 'net/http'
# url = URI.parse('https://ieeexplore.ieee.org.kwansei.remotexs.co/search/searchresult.jsp?newsearch=true&queryText=ICN')
# Net::HTTP.start(url.host, url.port) do |http|
#   req = Net::HTTP::Get.new(url.path)
#   puts http.request(req).body
# end


# require 'net/http'
# # url = URI.parse('https://ieeexplore.ieee.org.kwansei.remotexs.co/search/searchresult.jsp?newsearch=true&queryText=ICN')

# # response = Net::HTTP.get_response(url)
# # puts response.body

# uri = URI.parse('https://ieeexplore.ieee.org.kwansei.remotexs.co/search/searchresult.jsp?newsearch=true&queryText=ICN')
# http = Net::HTTP.new(uri.host, uri.port)
# request = Net::HTTP::Get.new(uri.request_uri)
# request.basic_auth("hus50851", "5v7bJ5ND")
# response = http.request(request)
# puts response

# Net::HTTP.start(url.host, url.port) do |http|
#   req = Net::HTTP::Get.new(url.path)
#   req.basic_auth('hus50851', '5v7bJ5ND')
#   puts http.request(req).body
# end



#browser.close



browser = Watir::Browser.new
browser.goto 'https://ieeexplore.ieee.org.kwansei.remotexs.co/Xplore/home.jsp'
browser.text_field(id:'username').set 'hus50851'
browser.text_field(id:'password').set '5v7bJ5ND'
browser.button(id: 'login').click


browser.text_field(xpath: '//*[@id="LayoutWrapper"]/div/div/div/div[3]/div/xpl-root/xpl-header/div/div/div/xpl-search-bar-migr/div/form/div[2]/div/div[1]/xpl-typeahead-migr/div/input').set("Information Centric Networking")
# browser.button(:text => 'submit').click
browser.button(type: 'submit').click

sleep 5
parsed_page = Nokogiri::HTML(browser.html)
File.open("parsed.html", "w") { |f| f.write "#{parsed_page}" }


title_arrays =[]

# if class name is space like "class = HI Han" then,
# you use to do like this  .css('.HI.Han')

# parsed_page.css('.col.result-item-align').css('a').map do |element|
#   contents = element.text
#   array_info.push(contents)
# end


parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
  contents = element.text
  title_arrays.push(contents)
end



for title in title_arrays  do
  puts "#{title}"
end

  #extracted_dvi.css('a')
  #char_element = char_element.css('a')
  #char_element.map {|element| element["_ngcontent-xcc"]}
  #char_element.map {|element| element["href"]}

# puts 'hello'

# parsed_page.css('div').css('a').each do |extracted_dvi|
#   #extracted_dvi.css('a')
#   #char_element = char_element.css('a')
#   #char_element.map {|element| element["_ngcontent-xcc"]}
#   #char_element.map {|element| element["href"]}
#   puts extracted_dvi
# end

# puts 'hello'
# puts 'hello'

# links = parsed_page.css('_ngcontent-wgn-c121')
# links.map {|element| element["href"]}
# puts links


  # File.open("parsed.txt", "w") { |f| f.write "#{parsed_page}" }

  # article_cards = parsed_page.xpath("//div[contains(@class, 'col result-item-align')]")
  # article_cards.each do |card|
  # puts article_cards
  # title = card.xpath("div[@class='_ngcontent-adj-c121']/a/@title")
  # link = card.xpath("div[@class='_ngcontent-adj-c121']/a/@href")
  # puts title
  # puts link
  # end




# https://ieeexplore.ieee.org.kwansei.remotexs.co/search/searchresult.jsp?newsearch=true&queryText=Information%5C%2FCentric%5C%2FNetworking
# browser.goto 'https://ieeexplore.ieee.org.kwansei.remotexs.co/search/searchresult.jsp?newsearch=true&queryText=ICN'
