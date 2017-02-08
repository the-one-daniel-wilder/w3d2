class Replies
  attr_accessor :body, :question_id, :parent_reply, :user_id

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
    SQL

    data.map { |datum| Replies.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_reply = options['parent_reply']
    @body = options['body']
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    data.map { |datum| Replies.new(datum) }
  end


  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    data.map { |datum| Replies.new(datum) }
  end


  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    return nil if data.length == 0
    Replies.new(data.first)
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    return nil if @parent_reply.nil?
    Replies.find_by_id(@parent_reply)
  end

  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply = ?
    SQL

    data.map { |datum| Replies.new(datum) }
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
    QuestionsDatabase.instance.execute(<<-SQL, @body, @question_id, @parent_reply, @user_id)
    INSERT INTO
      questions(@body, @question_id, @parent_reply, @user_id)
    VALUES
      (?, ?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, @body, @question_id, @parent_reply, @user_id, @id)
    UPDATE
      questions
    SET
      @body = ?, @question_id = ?, @parent_reply = ?, @user_id = ?
    WHERE
      id = ?
    SQL
  end
  
end
