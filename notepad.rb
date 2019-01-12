require_relative 'lib/post'
require_relative 'lib/bookmark'
require_relative 'lib/memo'
require_relative 'lib/task'
require 'optparse'

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: notepad.rb [options]'
  opt.on('-h', 'Prints this help') do
    STDOUT.puts opt
    exit
  end

  opt.on('--type POST_TYPE','какой тип постов показывать (по умолчанию все типы)') { |o| options[:type] = o }
  opt.on('--id POST_ID', 'если задан id - только этот пост') { |o| options[:id] = o }
  opt.on('--limit NUMBER', 'количество последних постов(по умолчанию все)') { |o| options[:limit] = o }
end.parse!

result = Post.find(options[:type], options[:id], options[:limit])

if result.nil?
  STDOUT.puts "id#{options[:id]} не найден"
elsif result.is_a? Post
  STDOUT.puts "Запись #{result.class.name}, id#{options[:id]}", result.to_strings
else
  STDOUT.print "\n", '|         id          ' \
                     '|        type         ' \
                     '|     created_at      ' \
                     '|        text         ' \
                     '|         url         ' \
                     '|      due_date       |'
  STDOUT.puts "\n", '_' * 133

  result.each do |row|
    row.each do |element|
      content = "#{element.to_s.delete('\n')[0..18]}"
      STDOUT.print '| ', content, ' ' * (20 - content.size)
    end
    STDOUT.print "|\n"
  end
end
