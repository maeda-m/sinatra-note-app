# frozen_string_literal: true

require 'pg'
require_relative 'note/gateway'

# Finder
module Note
  class RecordNotFound < StandardError
  end

  def find(record_id)
    records = []

    with_connection do |conn|
      result = conn.exec_params('SELECT * FROM notes WHERE id = $1;', [record_id])
      result.each { |row| records << Note::Gateway.new(row) }
    end
  rescue PG::InvalidTextRepresentation
    raise RecordNotFound
  else
    raise RecordNotFound if records.empty?

    records.first
  end

  def where(session_id:)
    records = []
    with_connection do |conn|
      result = conn.exec_params('SELECT * FROM notes WHERE session_id = $1 ORDER BY updated_at;', [session_id])
      result.each { |row| records << Note::Gateway.new(row) }
    end

    records
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
    records = []
    with_connection do |conn|
      result = conn.exec('SELECT * FROM notes ORDER BY updated_at;')
      result.each { |row| records << Note::Gateway.new(row) }
    end

    records
  end

  def with_connection
    config = "postgresql://#{ENV['POSTGRES_USER']}@#{ENV['POSTGRES_HOST']}:5432/#{ENV['POSTGRES_DB']}"
    @@connection ||= PG.connect(config)

    yield(@@connection)
  end

  module_function :find, :where, :build, :create, :all, :with_connection
end
