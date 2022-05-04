# frozen_string_literal: true

# View Helper
module NoteHelper
  def self.included(klass)
    klass.attr_reader :page_title
  end

  def render_message
    message = session.delete(:message)
    return if message.nil? || message.empty?

    "<article><aside>#{message}</aside></article>"
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end

  def edit_button(note)
    "<a href='/#{note.id}/edit' class='edit-button'><i>編集する</i></a>"
  end

  def destroy_button(note)
    <<-HTML
    <form action="/#{note.id}" method="post" class="destroy-action">
      <input type="hidden" name="_method" value="delete">
      <input type="submit" value="削除する" class="destroy-button">
    </form>
    HTML
  end
end
