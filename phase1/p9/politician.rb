require 'sqlite3'
require 'active_support/inflector'
require 'rspec'

DB_FILE = 'politicians.db'

$db = SQLite3::Database.new DB_FILE
$db.results_as_hash = true

class LameORM

  def initialize(args)
    args.each { |name, value| instance_variable_set("@#{name}", value) }
  end

  def self.where(condition, value)
    query = "SELECT * FROM #{table_name} WHERE #{condition}"
    result_to_objs $db.execute(query, value)
  end

  def self.count
    query = "SELECT COUNT(*) FROM #{table_name}"
    $db.execute(query).first[0]
  end

  def save
    if @id.nil?
      $db.execute insert_query
      @id = get_id
    else
      $db.execute update_query(@id)
    end
  end

  def delete
    if @id.nil?
      nil
    else
      $db.execute delete_query
    end
  end

  private

  def get_id
    fields = self.class.fields
    query = "SELECT id FROM #{self.class.table_name}"
    query += ' WHERE ' + fields_values_query(fields).join(' AND ')
    $db.execute(query).first.fetch("id")
  end

  def insert_query
    fields = self.class.fields
    query = "INSERT INTO #{self.class.table_name} (#{fields.join(', ')})"
    query += " VALUES "
    query += '(' + get_values(fields).map { |value| "'#{value}'" }.join(', ') + ')'
    query
  end

  def update_query(id)
    fields = self.class.fields
    query = "UPDATE #{self.class.table_name}"
    query += " SET " + fields_values_query(fields).join(', ')
    query += " WHERE id = #{id}"
    query
  end

  def fields_values_query(fields)
    set_query = fields.zip(get_values(fields))
    set_query.map! { |field_value_pair| "#{field_value_pair[0]} = '#{field_value_pair[1]}'" }
  end

  def delete_query
    query = "DELETE FROM #{self.class.table_name}"
    query += " WHERE id = #{@id}"
    query
  end

  def get_values(fields)
    values = []
    fields.each do |name|
      values << instance_variable_get("@#{name}")
    end
    return values
  end

  def self.result_to_objs(result)
    result.map do |row|
      self.new(result_row_to_args(row))
    end
  end

  def self.result_row_to_args(row)
    row.reject { |k| k.is_a? Numeric }
  end

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.fields
    $db.execute("PRAGMA table_info(#{table_name});").map { |field| field[1] }.reject { |field| field == 'id' }
  end

end

class Politician < LameORM
  attr_accessor :name

end

politician = Politician.new({"name"=>"BOBBY", "party"=>"R", "location"=>"SC (33.99855000018255, -81.0452500001872)", "grade_level_since_1996"=>7.945704026, "grade_level_112th_congress"=>7.945704026, "years_in_congress"=>1, "dw1_score"=>0.819})
politician.save
politician.name = 'martino'
politician.save
politician.delete
p Politician.where('name = ?', 'Rep. Colleen Hanabusa')
