class Task < Post
  def getdata
    @post_io.output('What should be done?')
    @text = @post_io.input

    @post_io.output('What date (dd.mm.yyyy) do you need to do this?')
    @due_date = Date.parse(@post_io.input)
  end

  def to_strings
    time_string = "Created at: #{@created_at.strftime('%d.%m.%Y, %H:%M:%S')}\n\n"
    dead_line   = "Due date: #{@due_date.strftime('%Y.%m.%d')}"
    [time_string, @text, dead_line]
  end

  def to_db_hash
    super.merge(text: @text, due_date: @due_date.to_s)
  end

  def load_data(data_hash)
    super(data_hash)
    @due_date = Date.parse(data_hash[:due_date])
    @text = data_hash[:text]
  end
end
