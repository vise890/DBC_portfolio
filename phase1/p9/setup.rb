require 'csv'
require 'sqlite3'
require 'rspec'

CSV_FILE = 'politician_data.csv'
DB_FILE = 'politicians.db'

$db = SQLite3::Database.new DB_FILE

module PoliticianDB

  def self.setup
    query = <<-SQL
      CREATE TABLE politicians (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(64) NOT NULL,
        party VARCHAR(64) NOT NULL,
        location VARCHAR(64) NOT NULL,
        grade_level_since_1996 FLOAT NOT NULL,
        grade_level_112th_congress FLOAT NOT NULL,
        years_in_congress INTEGER NOT NULL,
        dw1_score FLOAT NOT NULL
      );
    SQL
    $db.execute(query)
  end

  def self.seed
    CSV.open(CSV_FILE).each_with_index do |row, row_number|
      next if row_number == 0
      query = <<-SQL
        INSERT INTO politicians
        (name, party, location, grade_level_since_1996, grade_level_112th_congress, years_in_congress, dw1_score)
        VALUES
        SQL
      query += '(' + row.map { |value| "'#{value}'" }.join(', ') + ")"
      $db.execute(query)
    end
  end

  def self.drop
    # drop 'em tables
    query = 'DROP TABLE politicians'
    $db.execute(query)
  end

  private

  def self.headers
    headers = CSV.open(CSV_FILE).read.first
    headers.map! { |header| header.downcase.gsub(/\s+/, '_').gsub(/[\(\)]/, '') }
    p headers
  end

end

#PoliticianDB.drop
PoliticianDB.setup
PoliticianDB.seed

