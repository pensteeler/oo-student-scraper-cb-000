require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    students = []

    #doc = Nokogiri::HTML(open("http://learn-co-curriculum.github.io/site-for-scraping/courses"))experiment
    doc = Nokogiri::HTML( open(index_url) )

    #doc.css(".post").each do |post|
    #  course = Course.new
    #  course.title = post.css("h2").text
    #  course.schedule = post.css(".date").text
    #  course.description = post.css("p").text
    #end

    doc.css("div.roster-cards-container").each do |roster_cards|
      roster_cards.css("div.student-card").each do |student_card|

        studentName = student_card.css("a h4.student-name").text
        studentLocation = student_card.css("a p.student-location").text
        studentProfile = student_card.css('a')[0]['href']

        #puts "\nStudent Name:#{studentName}"
        #puts "Student Location:#{studentLocation}"
        #puts "Student Profile:#{studentProfile}\n"

        students << { name: studentName, location: studentLocation, profile_url: studentProfile }
      end

    end
    students
  end

  def self.scrape_profile_page(profile_url)

    student = {}
    #blog, github, linkedin, profile_quote, twitter, bio

    #puts "Opening:#{profile_url}"
    student_profile = Nokogiri::HTML( open(profile_url) )

    student[:bio] = student_profile.css("div.description-holder p").text
    student[:profile_quote] =  student_profile.css("div.profile-quote").text

    #twitter = student_profile.css('div.social-icon-container a')[0]['href']
    #linkedin = student_profile.css('div.social-icon-container a')[1]['href']
    #github = student_profile.css('div.social-icon-container a')[2]['href']
    #blog = student_profile.css('div.social-icon-container a')[3]['href']

    #social_media = student_profile.css('div.social-icon-container a')['href'].text
    #social_media = student_profile.css("div.social-icon-container a[href]")
    #news_links = page.css("a").select{|link| link['data-category'] == "news"}
    social_media = student_profile.css("a")
    #puts "Social Media Links:#{social_media}"

    social_media.each do |socialLink|
      #puts "Checking:#{socialLink['href']}"
      if socialLink['href'].include?("twitter")
        student[:twitter] = socialLink['href']
      elsif socialLink['href'].include?("linkedin")
        student[:linkedin] = socialLink['href']
      elsif socialLink['href'].include?("github")
          student[:github] = socialLink['href']
      elsif  socialLink['href'].include?(".com")
          student[:blog] =  socialLink['href']
      end
    end

    student
  end

end
