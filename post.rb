class Post
  def initialize
    @created_at = Time.now
    @text       = nil
  end

  def read_from_console
    # todo
  end

  def to_strings
    # todo
  end

  def save
    File.write(file_path, to_strings)
  end

  def file_path
    current_path = __dir__
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")
    current_path + '/' + file_name
  end
end
