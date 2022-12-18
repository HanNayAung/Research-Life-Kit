#!/usr/bin/ruby

# Need to Install 'watir' , 'webdrivers', 'nokogiri' gems

require_relative "research_life_kit/version"
require 'watir'
require 'webdrivers'
require 'nokogiri'


# module ResearchLifeKit
#   class Error < StandardError; end
#   # Your code goes here...
#   puts "hello"
# end

class Ieice
  attr_accessor :user, :password, :keyword, :num_of_papers

  def initialize()
    @titles_array =[]
  end

  def titles
    url = 'https://ieeexplore.ieee.org.kwansei.remotexs.co/Xplore/home.jsp'
    browser = Watir::Browser.new
    browser.window.maximize
    browser.goto url

    # Login
    browser.text_field(id:'username').set user
    browser.text_field(id:'password').set password
    browser.button(id: 'login').click

    # Search According to Keyword
    xpath = '//*[@id="LayoutWrapper"]/div/div/div/div[3]/div/xpl-root/xpl-header/div/div/div/xpl-search-bar-migr/div/form/div[2]/div/div[1]/xpl-typeahead-migr/div/input'
    browser.text_field(xpath: xpath).set keyword
    browser.button(type: 'submit').click

    # Insert each title into title_arrays
    sleep 3
    parsed_page = Nokogiri::HTML(browser.html)
    parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
      contents = element.text
      @titles_array.push(contents)
    end

    if num_of_papers >= 2
      2.upto(num_of_papers) do |number|
        puts number
        browser.window.maximize
        browser.scroll.to :bottom
        browser.div(:class => "pagination-bar hide-mobile text-base-md-lh").ul.li(:text => number.to_s).click
        sleep 3
        parsed_page = Nokogiri::HTML(browser.html)

        parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
          contents = element.text
          @titles_array.push(contents)
        end
      end
    end

    for title in @titles_array  do
      puts "#{title}"
    end
  end

  def titles_save
    # File.open("titles.org")
    # for title in @titles_array  do
    #   File.write("titles.org","#{title}")
    # end

    File.open("titles.org", "w") { |file| file.write '#{titles_arrays}' }

    # File.open('titles.org', 'w') { |f| @titles_array.each { |line| f << line + '\n' } }
    # File.open("parsed.html", "w") { |f| f.write "#{parsed_page}" }
  end
end

organization_instance = Ieice.new
organization_instance.user = "hus50851"
organization_instance.password = "5v7bJ5ND"
organization_instance.keyword = "Information Centric Networking"
organization_instance.num_of_papers =3
puts organization_instance.titles
puts organization_instance.titles_save


# browser = Watir::Browser.new
# browser.window.maximize
# browser.goto 'https://ieeexplore.ieee.org.kwansei.remotexs.co/Xplore/home.jsp'
# browser.text_field(id:'username').set 'hus50851'
# browser.text_field(id:'password').set '5v7bJ5ND'
# browser.button(id: 'login').click
# browser.text_field(xpath: '//*[@id="LayoutWrapper"]/div/div/div/div[3]/div/xpl-root/xpl-header/div/div/div/xpl-search-bar-migr/div/form/div[2]/div/div[1]/xpl-typeahead-migr/div/input').set("Information Centric Networking")
# # browser.button(:text => 'submit').click
# browser.button(type: 'submit').click
# sleep 5
# parsed_page = Nokogiri::HTML(browser.html)
# File.open("parsed.html", "w") { |f| f.write "#{parsed_page}" }
# title_arrays =[]
# parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
#   contents = element.text
#   title_arrays.push(contents)
# end
# for title in title_arrays  do
#   puts "#{title}"
# end


# ###

# browser.scroll.to :bottom
# # browser.scroll.to [0, 2000]


# browser.div(:class => "pagination-bar hide-mobile text-base-md-lh").ul.li(:text => '2').click
# sleep 5

# parsed_page = Nokogiri::HTML(browser.html)
# File.open("parsed.html", "w") { |f| f.write "#{parsed_page}" }

# parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
#   contents = element.text
#   title_arrays.push(contents)
# end

# for title in title_arrays  do
#   puts "#{title}"
# end

# File.open("title.org", "w") { |f| f.write "#{title_arrays}" }










# browser.button('//*[@id="xplMainContent"]/div[2]/div[2]/xpl-paginator/div[2]/ul/li[3]').click()
# browser.div(:class => "pagination-bar hide-mobile text-base-md-lh").ul.li(:class => "stats-Pagination_2").click
# browser.div(:class => "pagination-bar.hide-mobile.text-base-md-lh").ul.li.a(:class => 'stats-Pagination_2').click
# browser.a(:class => "stats-Pagination_2").click
# browser.div(:class => "pagination-bar hide-mobile text-base-md-lh").ul.li(:class => "stats-Pagination_2 active").click


# class="stats-Pagination_2 active"

# sleep 5
# parsed_page = Nokogiri::HTML(browser.html)
# File.open("parsed.html", "w") { |f| f.write "#{parsed_page}" }


# title_arrays =[]

# parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
#   contents = element.text
#   title_arrays.push(contents)
# end


#browser.button(type: 'submit').click
# browser.frame(class: "stats-Pagination_2").click

#browser.frame(:class, 'pagination-bar.hide-mobile.text-base-md-lh
# ').div(:class, 'stats-Pagination_2').click

# browser.frame(xpath: '//*[@id="xplMainContent"]/div[2]/div[2]/xpl-paginator/div[2]/ul/li[2]/a').click


# if class name is space like "class = HI Han" then,
# you use to do like this  .css('.HI.Han')
# parsed_page.css('.col.result-item-align').css('a').map do |element|
#   contents = element.text
#   array_info.push(contents)
# end


#extracted_dvi.css('a')
#char_element = char_element.css('a')
#char_element.map {|element| element["_ngcontent-xcc"]}
#char_element.map {|element| element["href"]}

# parsed_page.css('div').css('a').each do |extracted_dvi|
#   #extracted_dvi.css('a')
#   #char_element = char_element.css('a')
#   #char_element.map {|element| element["_ngcontent-xcc"]}
#   #char_element.map {|element| element["href"]}
#   puts extracted_dvi
# end

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
