# frozen_string_literal: true

module Note
  # Row Data Gateway
  class Gateway
    attr_accessor :id, :title, :content, :session_id, :updated_at

    def initialize(attrs)
      attrs.each { |k, v| send("#{k}=", v) }
    end

    def create
      values = [
        title,
        content,
        session_id,
        Time.now
      ]

      Note.with_connection do |conn|
        conn.exec_params('INSERT INTO notes (title, content, session_id, updated_at) VALUES ($1, $2, $3, $4);', values)
      end
    end

    def update(attrs)
      values = [
        attrs[:title],
        attrs[:content],
        attrs[:session_id],
        Time.now,
        id
      ]

      Note.with_connection do |conn|
        conn.exec_params('UPDATE notes SET title = $1, content = $2, session_id = $3, updated_at = $4 WHERE id = $5;', values)
      end
    end

    def destroy
      Note.with_connection do |conn|
        conn.exec_params('DELETE FROM notes WHERE id = $1;', [id])
      end
    end
  end
end
