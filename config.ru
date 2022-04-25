# frozen_string_literal: true

require_relative 'note_app'

run Rack::URLMap.new({
  '/' => NoteApp,
  '/notes' => NoteApp
})
