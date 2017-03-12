module Scraper
  module Console
    def sle
      #####################################################################
      #
      # SCRAPE LEARN STATIC BOOTCAMP PAGE FOR LINKS
      #
      #####################################################################
      
      check = %w(Welcome Intro\ to\ Ruby\ Development HTML\ and\ CSS)
      url = "#{Rails.root}/tmp/menu.html"
      doc =  Nokogiri::HTML(open(url))

      #Gets us our main nodes.      
      dyne, lesson = nil, nil
      nodes = doc.css("li.site-nav__item.site-nav__item--level-1")
      course = Course.create(name: "Full Stack Community Bootcamp")

      nodes.each do |unit|
        unless check.include?(unit.css("a")[0].text) 
          unit.css("a").each_with_index do |grain, z|
            if z == 0
              unit = Unit.create(name: grain.text, course: course) if z == 0
            else
              link = grain.attr("href")

              if link == '#'
                dyne = Dyne.create(name: grain.text, unit: unit)
              else
                Lesson.create(name: grain.text, learn_link: link, dyne: dyne)
              end
            end
          end
        end
      end
    end

    def wle
      #####################################################################
      #
      # WRITE STATIC LEARN DATA 2 SEED FILE!
      #
      #####################################################################
      puts "Solved by Seed Dump!!"
    end

    def crawl
      #####################################################################
      #
      # CRAWL EACH LESSON FOR GITHUB LEARN LINK ;) + SLEEP & UA
      #
      #####################################################################

      #Let's just start off with a login and then we will see if we can scrape two
      #pages and return the correct links. If that works then we will start a slow
      
      a = Mechanize.new {|agent| agent.user_agent_alias = 'Mac Safari'}

      #First lets login to learn
      f = a.get('https://learn.co/sign_in').forms.first
      f['user[email]'] = 'andre@vollrath.ca' 
      f['user[password]'] = ''
      f.submit

      sleep(rand(1..5))

      #Now we will try to navigate to an abitrary page &
      #collect the github link we are after!
      Lesson.find_each(start: 591, finish: 597, batch_size: 1).each do |lesson|
        page = a.get("https://learn.co#{lesson.learn_link}")
        doc = Nokogiri::HTML(page.body)
        
        root = doc.search("script").text.match(/"assessable_github_source":"[\w-]+"/)[0]
        lesson.update(github_root: root.delete('\"')[25..-1])
    
        #Keep track of our links make sure we're not generating some sort of error
        puts "Learn link:  #{lesson.learn_link}"
        puts "Github link: #{lesson.github_root}"

        #have a nice nap inbetween
        sleep(rand(5..30))
      end
      puts "..Done"
    end


      #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      # OTHER COURSE AND UNIT CRAWLS!
      #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  end
end