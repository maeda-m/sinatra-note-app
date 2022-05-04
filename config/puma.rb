# frozen_string_literal: true

require_relative '../lib/note'

workers 1
silence_single_worker_warning

on_worker_boot do
  Note.establish_connection
end

on_worker_shutdown do
  Note.close_connection
end
