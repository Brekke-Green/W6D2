require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    columns = DBConnection.execute2(<<-SQL)
      SELECT *
      FROM ("#{table_name}") 
    SQL

    @columns = columns.first.map {|col_name| col_name.to_sym}
  end

  def self.finalize!
    self.columns
    @columns.each do |col|
      define_method(col) do
        self.attributes[col]
      end
      define_method("#{col}=") do |val = nil|
        self.attributes[col] = val
      end
    end 
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    data = DBConnection.execute(<<-SQL, self.table_name)
      SELECT 
        *
      FROM
        (#{self.table_name})
    SQL
    data.map{}
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, attr_value|
      attr_name = attr_name.to_sym
      if !self.class.columns.include?(attr_name) 
        raise "unknown attribute '#{attr_name}'"
      end 
      self.send("#{attr_name}=", attr_value) 
    end 
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
