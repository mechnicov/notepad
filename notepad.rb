require_relative 'lib/post'
require_relative 'lib/bookmark'
require_relative 'lib/memo'
require_relative 'lib/task'
require 'optparse'

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: notepad.rb [options]'
  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--id POST_ID', 'show only post with specified id') { |o| options[:id] = o }
  opt.on('--type POST_TYPE','what type of posts to show (all types by default)') { |o| options[:type] = o }
  opt.on('--limit NUMBER', 'number of recent posts (all posts by default)') { |o| options[:limit] = o }
end.parse!

if options[:id]
  result = Post.find_by_id(options[:id])
  raise "id#{options[:id]} not found" if result.nil?
  puts "Post #{result.class.name}, id#{options[:id]}", result.to_strings
else
  result = Post.find_all(options[:type], options[:limit])
  print "\n", '|         id          ' \
              '|        type         ' \
              '|     created_at      ' \
              '|        text         ' \
              '|         url         ' \
              '|      due_date       |'
  puts "\n", '_' * 133

  result.each do |row|
    row.each do |element|
      content = "#{element.to_s.delete('\n')[0..18]}"
      print '| ', content, ' ' * (20 - content.size)
    end
    print "|\n"
  end
end
