namespace :db do
  desc "Fill database with sample data"
  task populate_topics: :environment do

    make_topics
  end
end

def make_topics
  topics = ["Linux","Android", "iPhone", "Ruby on Rails","Python", "Startups", "HTML5", "CSS3", "Javascript", "Nodejs", "git", "Ubuntu", "Programming", "C#", "Windows", "html", "Computer Security", "Java", "PHP", "C++", "Cloud", "Apple", "Chrome", "JQuery", "Firefox", "Unix", "Mobile", "Gadgets", "Django", "Vim", "Ruby", "Emacs", "Sublime", "Free and Open Source", "Unix", "LaTeX", "Linux Mint", "Technology News", "Debian", "Database", "Amazon AWS"]
  topics.each do |topic|
    Topic.create!(name: topic)
  end
end
