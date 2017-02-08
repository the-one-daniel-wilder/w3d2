require 'singleton'
require 'sqlite3'
require_relative 'question'
require_relative 'user'
require_relative 'replies'
require_relative 'question_follows'
require_relative 'question_likes'
require_relative 'super_tables'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end
