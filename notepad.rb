require_relative 'lib/post'
require_relative 'lib/bookmark'
require_relative 'lib/memo'
require_relative 'lib/task'


STDOUT.puts 'Блокнот', 'Что хотите записать?'

choices = Post.types

choice = nil
until ("1".."#{choices.size}").include? choice
  choices.each_with_index { |type, index | STDOUT.puts "#{index + 1}. #{type}" }
  choice = STDIN.gets.chomp
end
choice = choice.to_i - 1

entry = Post.create(choice)
entry.read_from_console
entry.save

STDOUT.puts 'Запись успешно сохранена'
