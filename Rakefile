# frozen_string_literal: true

require 'rake/testtask'

ENV['APP_ENV'] = 'TEST'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end
