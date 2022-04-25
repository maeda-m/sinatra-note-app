# frozen_string_literal: true

require 'active_hash'

class Note < ActiveYaml::Base
  set_root_path 'values'
  set_filename 'note'

  fields :id, :session_id, :title, :content

  def save
    self.id = SecureRandom.uuid if id.nil?

    File.open(full_path, 'a') do |f|
      f.write(to_yaml)
    end
    force_reload

    true
  end

  def update(attrs)
    destroy && self.class.new(attrs).save
  end

  def destroy
    File.open(full_path, 'r') do |f|
      File.write(full_path, f.read.sub(to_yaml, ''))
    end
    force_reload

    true
  end

  def to_yaml
    plain_hash = attributes.to_h.transform_keys(&:to_s)
    yaml = ([plain_hash]).to_yaml

    yaml.sub(/\A---\n/, '')
  end

  private

  def full_path
    self.class.full_path
  end

  def force_reload
    self.class.reload(true)
  end
end
