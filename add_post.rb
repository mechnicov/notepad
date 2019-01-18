require_relative 'lib/post'
require_relative 'lib/bookmark'
require_relative 'lib/memo'
require_relative 'lib/task'


STDOUT.puts 'Notepad', 'What do you want to post?'

choices = Post.post_types.keys

choice = nil
until ("1".."#{choices.size}").include? choice
  choices.each.with_index(1) { |type, index| STDOUT.puts "#{index}. #{type}" }
  choice = STDIN.gets.chomp
end
choice = choice.to_i - 1

entry = Post.create(choices[choice])
entry.get_from_console
id = entry.save_to_db

STDOUT.puts "Post saved successfully with id#{id}"
