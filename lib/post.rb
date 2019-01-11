require 'sqlite3'

class Post
  def self.post_types
    { Bookmark: Bookmark, Memo: Memo, Task: Task }
  end

  def self.create(type)
    post_types[type].new
  end

  def initialize
    @created_at = Time.now
  end

  def read_from_console; end

  def to_strings; end

  def save
    file = File.new(file_path, 'a')
    to_strings.each { |string| file.puts(string) }
    separator = '---------------------------------------------'
    file.puts(separator)
    file.close
  end

  def file_path
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d.txt")
    "#{__dir__}/../posts/#{file_name}"
  end

  def save_to_db
    db = SQLite3::Database.open("#{__dir__}/../notepad.sqlite")
    db.results_as_hash = true

    db.execute("INSERT INTO posts (#{to_db_hash.keys.join(',')}) VALUES (#{('?,' * to_db_hash.keys.size).chomp(',')})", to_db_hash.values)
    insert_row_id = db.last_insert_row_id
    db.close
    insert_row_id
  end

  def to_db_hash
    { type: self.class.name, created_at: @created_at.to_s }
  end
end
