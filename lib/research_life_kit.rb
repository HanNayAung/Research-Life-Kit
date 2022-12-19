#!/usr/bin/ruby

# In order to run, need to Install 'watir' , 'webdrivers', 'nokogiri'
# gems.

require_relative "research_life_kit/version"
require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'watir-scroll'

# module ResearchLifeKit
#   class Error < StandardError; end
#   # Your code goes here...
#   puts "hello"
# end

class Ieice
  attr_accessor :user, :password, :keyword, :num_of_papers

  def initialize()
    # paper title
    @paper_title_array = []
    # abstract of paper
    @paper_abstract_array = []
    # paper's id
    @paper_id_array = []
    # store temporary
    @tmp_array = []
  end

  def titles
    url = 'https://ieeexplore.ieee.org.kwansei.remotexs.co/Xplore/home.jsp'
    browser = Watir::Browser.new
    # browser.window.maximize
    browser.goto url

    # Login
    browser.text_field(id:'username').set user
    browser.text_field(id:'password').set password
    browser.button(id: 'login').click

    # Search According to Keyword
    xpath = '//*[@id="LayoutWrapper"]/div/div/div/div[3]/div/xpl-root/xpl-header/div/div/div/xpl-search-bar-migr/div/form/div[2]/div/div[1]/xpl-typeahead-migr/div/input'
    browser.text_field(xpath: xpath).set keyword
    browser.button(type: 'submit').click
    sleep 5

    # Insert each paper title in the current page into paper_title_array
    parsed_page = Nokogiri::HTML(browser.html)
    parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
      @paper_title_array.push(element.text)
    end
    # Insert each paper id in the current page into paper_id_array
    parsed_page.css('div.List-results-items').map do |element|
      @paper_id_array.push(element.attribute("id"))
    end
    # Show Abstract of each paper in the current page
    for id in @paper_id_array  do
      button = browser.div(:id => "#{id}").div.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract')
      button.scroll.to
      button.click
    end
    parsed_page = Nokogiri::HTML(browser.html)
    # Insert each abstract of paper  in the current page into title_array
    parsed_page.css('div.js-displayer-content.u-mt-1.stats-SearchResults_DocResult_ViewMore.text-base-md-lh').map do |element|
      @paper_abstract_array.push(element.text)
    end
    sleep 5

    if num_of_papers >= 2
      2.upto(num_of_papers) do |number|
        puts number
        # browser.window.maximize
        browser.scroll.to :bottom
        browser.div(:class => "pagination-bar hide-mobile text-base-md-lh").ul.li(:text => number.to_s).click
        sleep 5
        parsed_page = Nokogiri::HTML(browser.html)
        # Insert each paper title in the current page into title_array
        parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
          @paper_title_array.push(element.text)
        end
        # Insert each paper id in the current page into paper_id_array
        parsed_page.css('div.List-results-items').map do |element|
          @tmp_array.push(element.attribute("id"))
        end

        # Show Abstract of each paper in the current page
        for id in @tmp_array  do
          button = browser.div(:id => "#{id}").div.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract')
          button.scroll.to
          button.click
        end
        parsed_page = Nokogiri::HTML(browser.html)
        # Insert each abstract of paper  in the current page into title_array
        parsed_page.css('div.js-displayer-content.u-mt-1.stats-SearchResults_DocResult_ViewMore.text-base-md-lh').map do |element|
          @paper_abstract_array.push(element.text)
        end

      end
    end

    # for title in @paper_title_array  do
    #   puts "#{title}"
    # end
  end

  def titles_save
    File.open("titles.org", "w+") do |file|
      @paper_title_array.each { |element| file.puts("* " + element) }
      @paper_id_array.each { |element| file.puts("** " + element) }
      @paper_abstract_array.each { |element| file.puts("*** " + element) }
    end
  end
end

organization_instance = Ieice.new
organization_instance.user = ""
organization_instance.password = ""
organization_instance.keyword = "Information Centric Networking"
organization_instance.num_of_papers =2
puts organization_instance.titles
puts organization_instance.titles_save



# File.open("parsed.html", "w") { |f| f.write "#{parsed_page}" }
# parsed_page.css('dvi.js-displayer-content.u-mt-1.stats-SearchResults_DocResult_ViewMore.text-base-md-lh').map do |element|
#   contents = element.text
#   puts contents
# end
#parsed_page.css('div.row.doc-access-tools-container').each do  |char_element|
#  browser.i(:class => "icon-size-md.icon-caret-abstract.color-xplore-blue").click
#end


   # browser.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract').click

    # browser.div(:id => '8685612')
    #   .div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract').click

    # buttons =[]
    # buttons.push(browser.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract'))
    # buttons.each do |button|
    #   button.scroll.to
    #   button.click
    #   puts "111"
    # end
    # sleep 50

    # while browser.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract').exists?
    #   button = browser.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract')
    #   button.scroll.to
    #   button.click
    #   puts "111"

    # end

# sleep 50

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
