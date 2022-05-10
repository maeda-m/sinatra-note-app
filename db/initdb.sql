CREATE TABLE IF NOT EXISTS notes (
  id         uuid DEFAULT gen_random_uuid(),
  title      varchar,
  content    text,
  session_id varchar(64) NOT NULL,
  updated_at timestamp(6) NOT NULL,
  PRIMARY KEY (id)
);
CREATE INDEX IF NOT EXISTS index_notes_on_id ON notes (id);
