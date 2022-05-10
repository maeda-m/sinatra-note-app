# frozen_string_literal: true

require_relative '../lib/note'
require 'test/unit'

class TestSql < Test::Unit::TestCase
  class << self
    def startup
      Note.establish_connection
    end

    def shutdown
      Note.close_connection
    end
  end

  def setup
    10.times { Note.create(session_id: 'dummy-session-id') }
    assert_equal 10, Note.all.count
  end

  def teardown
    Note.all.each(&:destroy)
  end

  def test_escape_sql
    attack = "' OR '1' --"

    ng_sql = "SELECT * FROM notes WHERE title = '#{attack}'"
    result = Note.instance_variable_get(:@connection).exec(ng_sql)
    assert_equal 10, result.count

    ok_sql = 'SELECT * FROM notes WHERE title = $1;'
    records = Note.execute_sql_with_build(ok_sql, [attack])
    assert_equal 0, records.count
  end
end
