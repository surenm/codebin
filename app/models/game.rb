class Game < ActiveRecord::Base
  belongs_to :player_a, class_name: "User"
  belongs_to :player_b, class_name: "User"

  has_one :snippet_engine, class_name: "Snippet"
  has_one :snippet_a, class_name: "Snippet"
  has_one :snippet_b, class_name: "Snippet"

  belongs_to :game_type

  accepts_nested_attributes_for :snippet_engine, :snippet_a, :snippet_b

  STATUS_WAITING = :waiting
  STATUS_QUEUED = :queued
  STATUS_RUNNING = :running
  STATUS_COMPLETED = :completed

  def self.available_game_statuses
    [STATUS_WAITING, STATUS_QUEUED, STATUS_RUNNING, STATUS_COMPLETED]
  end

  
end