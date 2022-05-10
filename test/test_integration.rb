# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

require_relative '../note_app'
require 'test/unit'
require 'rack/test'

class TestIntegration < Test::Unit::TestCase
  class << self
    def startup
      Note.establish_connection
    end

    def shutdown
      Note.close_connection
    end
  end

  def setup
    @user1 = Rack::Test::Session.new(Rack::MockSession.new(NoteApp))
    @user2 = Rack::Test::Session.new(Rack::MockSession.new(NoteApp))

    @user1.get '/'
    @user2.get '/'

    @user1_session_id = @user1.last_response.cookies['rack.session'].first
    @user2_session_id = @user2.last_response.cookies['rack.session'].first
  end

  def teardown
    Note.all.each(&:destroy)
  end

  def test_index
    empty_message = 'まだNoteがありません'

    # Note なし（user1）
    @user1.get '/'
    assert @user1.last_response.ok?
    assert_match empty_message, @user1.last_response.body

    # Note あり（user2）
    Note.create(title: 'たいとる', content: 'ないよう', session_id: @user2_session_id)
    @user2.get '/'
    assert @user2.last_response.ok?
    assert_not_match empty_message, @user2.last_response.body
  end

  def test_show
    # 該当するNoteが存在しない
    @user1.get '/dummy_id'
    assert @user1.last_response.not_found?

    # Note あり（user1）
    Note.create(title: 'たいとる', content: 'ないよう', session_id: @user1_session_id)
    note = Note.all.last
    @user1.get "/#{note.id}"
    assert @user1.last_response.ok?
    assert_match '<h1>たいとる</h1>', @user1.last_response.body
    assert_match '<pre>ないよう</pre>', @user1.last_response.body
  end

  def test_new
    @user1.get '/new'
    assert @user1.last_response.ok?
    assert_match '<h1>New Note</h1>', @user1.last_response.body
  end

  def test_create
    before_record_count = Note.all.count
    @user1.post '/', {
      title: 'たいとる1', content: 'ないよう1'
    }
    assert @user1.last_response.redirect?
    assert_equal 'http://example.org/', @user1.last_response.header['Location']
    assert_equal before_record_count + 1, Note.all.count

    note = Note.all.last
    assert_equal 'たいとる1', note.title
    assert_equal 'ないよう1', note.content
  end

  def test_edit
    # 該当するNoteが存在しない
    @user1.get '/dummy_id/edit'
    assert @user1.last_response.not_found?

    # Note あり（user1）
    Note.create(title: 'たいとる', content: 'ないよう', session_id: @user1_session_id)
    note = Note.all.last
    @user1.get "/#{note.id}/edit"
    assert @user1.last_response.ok?
    assert_match '<h1>Edit Note</h1>', @user1.last_response.body
  end

  def test_update
    Note.create(title: 'たいとる', content: 'ないよう', session_id: @user1_session_id)
    note = Note.all.last

    before_record_count = Note.all.count
    @user1.patch "/#{note.id}", {
      title: 'たいとる2', content: 'ないよう2'
    }
    assert @user1.last_response.redirect?
    assert_equal 'http://example.org/', @user1.last_response.header['Location']
    assert_equal before_record_count, Note.all.count

    note = Note.all.last
    assert_equal 'たいとる2', note.title
    assert_equal 'ないよう2', note.content
  end

  def test_destroy
    Note.create(title: 'たいとる', content: 'ないよう', session_id: @user1_session_id)
    note = Note.all.last

    before_record_count = Note.all.count
    @user1.delete "/#{note.id}"
    assert @user1.last_response.redirect?
    assert_equal 'http://example.org/', @user1.last_response.header['Location']
    assert_equal before_record_count - 1, Note.all.count
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
