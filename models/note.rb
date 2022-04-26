# frozen_string_literal: true

require 'active_hash'

# DataGateway
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
  end

  def update(attrs)
    destroy
    Note.create(attrs)
  end

  def destroy
    File.open(full_path, 'r') do |f|
      File.write(full_path, f.read.sub(to_yaml, ''))
    end
    force_reload
  end

  def to_yaml
    plain_hash = attributes.to_h.transform_keys(&:to_s)
    yaml = [plain_hash].to_yaml

    yaml.sub(/\A---\n/, '')
  end

  private

  def full_path
    Note.full_path
  end

  def force_reload
    Note.reload(true)
  end
end
