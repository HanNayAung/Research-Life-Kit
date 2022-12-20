#!/usr/bin/ruby
#
#
# Copyright (c) 2022, Han Nay Aung.
# All rights reserved.
#
# $Id: $
# In order to run, need to Install 'watir' , 'nokogiri', 'optparse' gems.

require_relative "research_life_kit/version"
require 'watir'
require 'nokogiri'
require 'optparse'

class Ieice
  attr_accessor :institutional, :keyword, :title, :page

  def initialize
    # paper title
    @paper_title_array = []
    # abstract of paper
    @paper_abstract_array = []
    # paper's id
    @paper_id_array = []
  end

  def extract_paper_title_abstract
    url = 'https://ieeexplore.ieee.org/Xplore/home.jsp'
    @browser = Watir::Browser.new
    # browser.window.maximize
    @browser.goto url

    # Search According to Keyword
    xpath = '/html/body/div[5]/div/div/div/div[3]/div/xpl-root/xpl-header/div/div/div/xpl-search-bar-migr/div/form/div[2]/div/div[1]/xpl-typeahead-migr/div/input'

    if keyword
      @browser.text_field(xpath: xpath).set keyword
    end
    if title
      @browser.text_field(xpath: xpath).set title
    end
    @browser.button(type: 'submit').click
    sleep 5

    # Insert each paper title in the current page into paper_title_array
    parsed_page = Nokogiri::HTML(@browser.html)
    parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
      @paper_title_array.push(element.text)
    end
    # Insert each paper id in the current page into paper_id_array
    parsed_page.css('div.List-results-items').map do |element|
      @paper_id_array.push(element.attribute("id"))
    end

    # Show Abstract of each paper in the current page
    for id in @paper_id_array  do
      button = @browser.div(:id => "#{id}").div.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract')
      button.scroll.to
      button.click
    end
    parsed_page = Nokogiri::HTML(@browser.html)
    # Insert each abstract of paper  in the current page into title_array
    parsed_page.css('div.js-displayer-content.u-mt-1.stats-SearchResults_DocResult_ViewMore.text-base-md-lh').map do |element|
      @paper_abstract_array.push(element.text)
    end

    if page.to_i >= 2
      for number in 2..page.to_i  do
        @paper_id_array = []
        @browser.scroll.to :bottom
        @browser.div(:class => "pagination-bar hide-mobile text-base-md-lh").ul.li(:text => number.to_s).click
        sleep 5
        parsed_page = Nokogiri::HTML(@browser.html)
        # Insert each paper title in the current page into title_array
        parsed_page.css('.col.result-item-align').css('h3.text-md-md-lh').map do |element|
          @paper_title_array.push(element.text)
        end
        # Insert each paper id in the current page into paper_id_array
        parsed_page.css('div.List-results-items').map do |element|
          @paper_id_array.push(element.attribute("id"))
        end
        # Show Abstract of each paper in the current page
        for id in @paper_id_array  do
          button = @browser.div(:id => "#{id}").div.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "js-displayer-control abstract-control u-flex-display-flex u-flex-align-items-center u-hover-text-dec-none stats_Abstract_ShowMore").span(:text => 'Abstract')
          button.scroll.to
          button.click
        end
        parsed_page = Nokogiri::HTML(@browser.html)
        # Insert each abstract of paper in the current page into title_array
        parsed_page.css('div.js-displayer-content.u-mt-1.stats-SearchResults_DocResult_ViewMore.text-base-md-lh').map do |element|
          @paper_abstract_array.push(element.text)
        end
      end
    end
  end


  def save_informations
    File.open("titles.org", "w+") do |file|
      @paper_title_array.each { |element| file.puts("* " + element) }
      @paper_abstract_array.each { |element| file.puts("** " + element) }
      @paper_id_array.each { |element| file.puts("*** " + element) }
    end
  end


  def download_paper_from_id
    # button = @browser.div(:id => '9350827').div.div(:class => 'row doc-access-tools-container').ul(:class => "List List--horizontal").li(:class => "List-item u-mr-2").a(:class => "stats_PDF_9350827 u-flex-display-flex").span(:text => 'Abstract')
    # button.scroll.to
    # button.click

    # url = 'https://ieeexplore.ieee.org.kwansei.remotexs.co/' +
    #       'stamp/stamp.jsp?tp=&arnumber=' + @paper_id_array[0]
    # @browser.goto url
    # sleep 5
    # parsed_page = Nokogiri::HTML(@browser.html)
    # File.open("parsed.html", "w") { |f| f.write "#{parsed_page}" }

    #@browser.button(id: 'download').click
    # puts @browser.div(:class => 'toolbar').exists?
    #.div(:id => 'toolbarContainer').div(:id => 'toolbarViewer').exists?
    # .div(:id => 'toolbarViewerRight').button(title: 'Download')
    # button.text == 'Submit' # => true
    # @browser.button(xpath: '//*[@id="download"]').click
  end

  def download_papers
  end

end

@website, @institutional, @keyword, @title, @page=''
OptionParser.new do |opts|
  opts.banner = "Usage: research_life_kit.rb [options]"
  opts.on("-w=s", "website") {|website| @website = website.to_s}
  opts.on("-i=s", "institutional") {|institutional| @institutional = institutional.to_s}
  opts.on("-k=s", "keyword") {|keyword| @keyword = keyword.to_s}
  opts.on("-t=s", "title") {|title| @title = title.to_s}
  opts.on("-p=s", "page") {|page| @page = page.to_s}
end.parse!

# puts @website, @institutional, @keyword, @page ,@title

if @website == 'ieice'
  organization_instance = Ieice.new
  if @keyword
    organization_instance.keyword = @keyword
  end
  if @title
    organization_instance.title = @title
  end
  if @page
    organization_instance.page = @page
  else
    organization_instance.page = 1
  end
  organization_instance.extract_paper_title_abstract
  organization_instance.save_informations
end

# url = 'https://ieeexplore.ieee.org.kwansei.remotexs.co/Xplore/home.jsp'
# @browser = Watir::Browser.new
# # browser.window.maximize
# @browser.goto url
# @browser.text_field(id:'username').set user
# @browser.text_field(id:'password').set password
# @browser.button(id: 'login').click
