# frozen_string_literal: true

module Note
  # Row Data Gateway
  class Gateway
    attr_accessor :id, :title, :content, :session_id, :updated_at

    def initialize(attrs)
      attrs.each { |k, v| send("#{k}=", v) }
    end

    def create
      sql = 'INSERT INTO notes (title, content, session_id, updated_at) VALUES ($1, $2, $3, $4);'
      values = [
        title,
        content,
        session_id,
        Time.now
      ]

      Note.with_connection { |conn| conn.exec_params(sql, values) }
    end

    def update(attrs)
      sql = 'UPDATE notes SET title = $1, content = $2, session_id = $3, updated_at = $4 WHERE id = $5;'
      values = [
        attrs[:title],
        attrs[:content],
        attrs[:session_id],
        Time.now,
        id
      ]

      Note.with_connection { |conn| conn.exec_params(sql, values) }
    end

    def destroy
      sql = 'DELETE FROM notes WHERE id = $1;'
      values = [id]

      Note.with_connection { |conn| conn.exec_params(sql, values) }
    end
  end
end
