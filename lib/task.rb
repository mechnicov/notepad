require 'date'
class Task < Post
  def read_from_console
    STDOUT.puts 'Что нужно сделать?'
    @text = STDIN.gets.chomp

    STDOUT.puts 'К какому числу (дд.мм.гггг) это нужно сделать?'
    @due_date = Date.parse(STDIN.gets.chomp)
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%d.%m.%Y, %H:%M:%S')}\n\n"
    dead_line   = "Крайний срок: #{@due_date.strftime('%Y.%m.%d')}"
    [time_string, @text, dead_line]
  end

  def to_db_hash
    super.merge(text: @text, due_date: @due_date.to_s)
  end
end
