class Memo < Post
  def read_from_console
    STDOUT.puts "Пишите заметку, когда закончите, на новой строке наберите 'end'"

    @text = []
    line = nil

    while line != 'end'
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop
  end

  def to_strings
    @text.unshift("Создано: #{@created_at.strftime('%d.%m.%Y, %H:%M:%S')}\n\n")
  end
end
