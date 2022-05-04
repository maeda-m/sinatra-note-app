# frozen_string_literal: true

require 'pg'
require_relative 'note/gateway'

# Finder
module Note
  class RecordNotFound < StandardError
  end

  def find(record_id)
    sql = 'SELECT * FROM notes WHERE id = $1;'
    values = [record_id]
    records = execute_sql_with_build(sql, values)
  rescue PG::InvalidTextRepresentation
    raise RecordNotFound
  else
    raise RecordNotFound if records.empty?

    records.first
  end

  def where(session_id:)
    sql = 'SELECT * FROM notes WHERE session_id = $1 ORDER BY updated_at;'
    values = [session_id]
    execute_sql_with_build(sql, values)
  end

  def build(attrs = {})
    Note::Gateway.new(attrs)
  end

  def create(attrs = {})
    record = build(attrs)
    record.create

    record
  end

  def all
    sql = 'SELECT * FROM notes ORDER BY updated_at;'
    execute_sql_with_build(sql)
  end

  def self.establish_connection
    puts 'Establishes the connection to the database.'
    config = "postgresql://#{ENV['POSTGRES_USER']}@#{ENV['POSTGRES_HOST']}:5432/#{ENV['POSTGRES_DB']}"
    @connection = PG.connect(config)
  end

  def self.execute_sql(sql, values = [], &block)
    result = @connection.exec_params(sql, values)
    result.map(&block) if block_given?
  end

  def self.execute_sql_with_build(sql, values = [])
    execute_sql(sql, values) { |attrs| build(attrs) }
  end

  def self.close_connection
    puts 'Close the connection to the database.'
    @connection.close
  end

  module_function :find, :where, :build, :create, :all
end
