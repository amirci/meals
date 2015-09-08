require "rails_helper"

RSpec.describe MealsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/meals").to route_to("meals#index")
    end

    it "routes to #create" do
      expect(post: "/api/v1/meals").to route_to("meals#create")
    end

  end
end
