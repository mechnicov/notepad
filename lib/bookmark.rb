class Bookmark < Post
  def getdata
    @post_io.output('Enter URL')
    @url = @post_io.input

    @post_io.output('What is it?')
    @text = @post_io.input
  end

  def to_strings
    time_string = "Created at: #{@created_at.strftime('%d.%m.%Y, %H:%M:%S')}\n\n"
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
