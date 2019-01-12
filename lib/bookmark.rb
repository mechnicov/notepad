class Bookmark < Post
  def get_from_console
    STDOUT.puts 'Введите адрес'
    @url = STDIN.gets.chomp

    STDOUT.puts 'Что это?'
    @text = STDIN.gets.chomp
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime('%d.%m.%Y, %H:%M:%S')}\n\n"
    [@url, @text, time_string]
  end

  def to_db_hash
    super.merge(text: @text, url: @url)
  end

  def load_data(data_hash)
    super(data_hash)
    @url = data_hash[:url]
    @text = data_hash[:text]
  end
end
