CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_reply INTEGER,
  user_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('George', 'Washington'),
  ('Joe', 'Dirt'),
  ('Steve', 'Jibson');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Blue Sky', 'Why is the sky blue?', (SELECT id FROM users WHERE fname = 'George' AND lname = 'Washington')),
  ('Magnets', 'How do they work?', (SELECT id FROM users WHERE fname = 'Joe' AND lname = 'Dirt'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (3, 1),
  (3, 2),
  (1, 1),
  (2, 2);

INSERT INTO
  replies (body, question_id, parent_reply, user_id)
VALUES
  ('Beacause it''s not black', 1, NULL, 3),
  ('Nobody knows', 2, NULL, 3),
  ('Haha, you''re very funny', 1, 1, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2, 1),
  (3, 2),
  (2, 2);
