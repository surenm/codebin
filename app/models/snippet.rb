class Snippet < ActiveRecord::Base
  belongs_to :user
  AVAILABLE_LANGUAGES = {
    ruby: "Ruby",
    python: "Python"
  }
end
