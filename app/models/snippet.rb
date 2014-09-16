class Snippet < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_one :container

  AVAILABLE_LANGUAGES = {
    ruby: {display: "Ruby", extension: 'rb', executable: 'ruby'},
    python: {display: "Python", extension: 'py', executable: 'python'}
  }

  STATE_QUEUED = :queued
  STATE_RUNNING = :running
  STATE_COMPLETED = :completed
  STATE_FAILED = :failed

  def extension
    AVAILABLE_LANGUAGES[language.to_sym][:extension] rescue ''
  end

  def executable
    AVAILABLE_LANGUAGES[language.to_sym][:executable] rescue ''
  end

  def self.available_statuses
    [STATE_QUEUED, STATE_RUNNING, STATE_COMPLETED, STATE_FAILED]
  end
  
end