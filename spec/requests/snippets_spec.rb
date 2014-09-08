require 'rails_helper'

RSpec.describe "Snippets", :type => :request do
  describe "GET /snippets" do
    it "works! (now write some real specs)" do
      get snippets_path
      expect(response.status).to be(200)
    end
  end
end
