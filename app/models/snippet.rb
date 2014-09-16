class Snippet < ActiveRecord::Base
  belongs_to :game
  has_one :container

  AVAILABLE_LANGUAGES = {
    ruby: {display: "Ruby", extension: 'rb', executable: 'ruby'},
    python: {display: "Python", extension: 'py', executable: 'python'}
  }

  def extension
    AVAILABLE_LANGUAGES[language.to_sym][:extension] rescue ''
  end

  def executable
    AVAILABLE_LANGUAGES[language.to_sym][:executable] rescue ''
  end

  STATE_QUEUED = :queued
  STATE_RUNNING = :running
  STATE_COMPLETED = :completed
  STATE_FAILED = :failed
end