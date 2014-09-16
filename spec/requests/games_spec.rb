require 'rails_helper'

RSpec.describe "Games", :type => :request do
  describe "GET /games" do
    it "works! (now write some real specs)" do
      get games_path
      expect(response.status).to be(200)
    end
  end
end
