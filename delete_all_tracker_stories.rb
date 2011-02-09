require 'rubygems'
require 'nokogiri'

TOKEN = '1234' # put your token here
PROJECT_ID = '82277' # project ID goes here
STORY_COMMAND = %[curl -H "X-TrackerToken: #{TOKEN}" -X GET http://www.pivotaltracker.com/services/v3/projects/#{PROJECT_ID}/stories]
PROJECT_INFO= %[curl -H "X-TrackerToken: #{TOKEN}" -X GET http://www.pivotaltracker.com/services/v3/projects/#{PROJECT_ID}]

xml = Nokogiri::XML(`#{STORY_COMMAND}`)
project_xml = Nokogiri::XML(`#{PROJECT_INFO}`)

project_name = project_xml.search('project').map { |node| node.at('name').text}

puts " --------------------------------- Are you SURE you want to delete #{project_name}? y or n  ---------------------------------"

confirm_delete = gets.chomp 

if confirm_delete == "y"
  ids = xml.search('story').map { |node| node.at('id').text }

  ids.each do |id|
    `curl -H "X-TrackerToken: #{TOKEN}" -X DELETE http://www.pivotaltracker.com/services/v3/projects/#{PROJECT_ID}/stories/#{id}`
    puts "deleted story: #{id}"
  end
  
else
  puts "Nothing will be deleted. Have a nice day."
  exit

end