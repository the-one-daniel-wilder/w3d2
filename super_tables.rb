require 'active_support/inflector'

class SuperTables

  def initialize
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.to_s.tableize}
      WHERE
        id = ?
    SQL

    return nil if data.length == 0
    self.new(data.first)
  end

end
