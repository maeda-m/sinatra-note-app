# frozen_string_literal: true

require 'active_hash'

class Note < ActiveYaml::Base
  set_root_path 'values'
  set_filename 'note'

  fields :id, :session_id, :title, :content

  def save
    save!

    true
  rescue
    false
  end

  def save!
    File.open(self.class.full_path, 'a') do |f|
      # TODO
    end
  end
end
