class Post
  def self.types
    [Bookmark, Memo, Task]
  end

  def self.create(index)
    types[index].new
  end

  def initialize
    @created_at = Time.now
  end

  def read_from_console
  end

  def to_strings
  end

  def save
    file = File.new(file_path, 'a')
    to_strings.each { |string| file.puts(string) }
    separator = '---------------------------------------------'
    file.puts(separator)
    file.close
  end

  def file_path
    current_path = __dir__
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d.txt")
    current_path + '/../posts/' + file_name
  end
end
