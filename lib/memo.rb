class Memo < Post
  def getdata
    @post_io.output("Write your memo. When done, type 'end' on the new line.")

    @text = []
    line = nil

    while line != 'end'
      line = @post_io.input
      @text << line
    end

    @text.pop
  end

  def to_strings
    @text.unshift("Created at: #{@created_at.strftime('%d.%m.%Y, %H:%M:%S')}\n\n")
  end

  def to_db_hash
    super.merge(text: @text.join('\n'))
  end

  def load_data(data_hash)
    super(data_hash)
    @text = data_hash[:text].split('\n')
  end
end
