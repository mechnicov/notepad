require 'sqlite3'
require 'date'

class Post
  SQLITE_DB_FILE = "#{__dir__}/../notepad.db".freeze

  def self.post_types
    { Bookmark: Bookmark, Memo: Memo, Task: Task }
  end

  def self.create(type, post_io)
    post_types[type].new(post_io)
  end

  def self.find_by_id(id)
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = true
    result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)
    db.close

    return nil if result.empty?

    result = result.first.select { |k, v| k.is_a? String }.to_h.map { |k, v| [k.to_sym, v] }.to_h

    post = self.create(result[:type].to_sym)
    post.load_data(result)
    post
  end

  def self.find_all(type, limit)
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = false

    query = "SELECT rowid, * FROM posts "
    query += "WHERE type = :type " unless type.nil?
    query += "ORDER by rowid DESC "
    query += "LIMIT :limit " unless limit.nil?

    statement = db.prepare(query)
    statement.bind_param('type', type) unless type.nil?
    statement.bind_param('limit', limit) unless limit.nil?

    result = statement.execute!

    statement.close
    db.close

    result
  end

  def initialize(post_io)
    @created_at = Time.now
    @post_io = post_io
  end

  def get_from_console; end

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
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = true

    begin
      db.execute("INSERT INTO posts (#{to_db_hash.keys.join(',')})
                    VALUES (#{('?,' * to_db_hash.keys.size).chomp(',')})", to_db_hash.values)
    rescue SQLite3::SQLException
      db.execute('CREATE TABLE posts (type STRING, created_at DATETIME, text TEXT, url TEXT, due_date DATETIME)')
      retry
    end

    insert_row_id = db.last_insert_row_id
    db.close
    insert_row_id
  end

  def to_db_hash
    { type: self.class.name, created_at: @created_at.to_s }
  end

  def load_data(data_hash)
    @created_at = Time.parse(data_hash[:created_at])
  end
end
