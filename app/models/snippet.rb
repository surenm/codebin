class Snippet < ActiveRecord::Base
  belongs_to :user
  has_one :container

  AVAILABLE_LANGUAGES = {
    ruby: {display: "Ruby", extension: 'rb'},
    python: {display: "Python", extension: 'py'}
  }

  def extension
    AVAILABLE_LANGUAGES[language.to_sym][:extension] rescue 'txt'
  end

  STATE_QUEUED = :queued
  STATE_RUNNING = :running
  STATE_COMPLETED = :completed
  STATE_FAILED = :failed
end