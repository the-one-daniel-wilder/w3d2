class User
  attr_accessor :fname, :lname

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
    SQL

    data.map { |datum| User.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions(author_id)
    Question.find_by_author_id(author_id)
  end

  def authored_replies(user_id)
    Reply.find_by_user_id(user_id)
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    return nil if data.length == 0
    User.new(data.first)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
        AND
        lname = ?
    SQL

    data.map { |datum| User.new(datum) }
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(@id)
  end

  def average_karma
    #returns number of likes / number of questions
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
       ( CAST(COUNT(user_id) AS FLOAT) / COUNT(DISTINCT(questions.id)) )
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ON question_likes.question_id = questions.id
    WHERE
      author_id = ?
    GROUP BY
      questions.id

    SQL

    return nil if data.length < 1
    data.first.values.first
  end

  def save
    if @id.nil?
      self.create
      return "saved"
    else
      self.update
      return "updated"
    end
  end

  protected

  def create
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
    INSERT INTO
      users(fname, lname)
    VALUES
      (?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    UPDATE
      users
    SET
      fname = ?, lname = ?
    WHERE
      id = ?
    SQL
  end

end
