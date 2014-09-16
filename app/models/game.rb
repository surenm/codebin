class Game < ActiveRecord::Base
  belongs_to :player_a, class_name: "User"
  belongs_to :player_b, class_name: "User"
  has_many :snippets
  belongs_to :game_type

  STATUS_WAITING = :waiting
  STATUS_QUEUED = :queued
  STATUS_RUNNING = :running
  STATUS_COMPLETED = :completed

  def self.available_game_statuses
    [STATUS_WAITING, STATUS_QUEUED, STATUS_RUNNING, STATUS_COMPLETED]
  end

  def ready?
    snippet_a = self.snippets.where(user: player_a)
    snippet_b = self.snippets.where(user: player_b)
    snippet_a.present? && snippet_b.present?
  end

  def name
    "Game #{id} - #{player_a.name} & #{player_b.name}"
  end
end