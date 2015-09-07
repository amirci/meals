require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe MealsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Meal. As you add validations to Meal, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes)   { attributes_for :meal }

  let(:invalid_attributes) { attributes_for :invalid_meal }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MealsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    before do
      FoodDiary.create_days 1
    end
    it "assigns all meals grouped by date @meals" do
      meals = Meal.totals_by_date
      get :index, {}, valid_session
      expect(assigns(:meals)).to eq meals
    end
  end

  # describe "GET #show" do
  #   it "assigns the requested meal as @meal" do
  #     meal = Meal.create! valid_attributes
  #     get :show, {:id => meal.to_param}, valid_session
  #     expect(assigns(:meal)).to eq(meal)
  #   end
  # end
  #
  # describe "GET #new" do
  #   it "assigns a new meal as @meal" do
  #     get :new, {}, valid_session
  #     expect(assigns(:meal)).to be_a_new(Meal)
  #   end
  # end
  #
  # describe "GET #edit" do
  #   it "assigns the requested meal as @meal" do
  #     meal = Meal.create! valid_attributes
  #     get :edit, {:id => meal.to_param}, valid_session
  #     expect(assigns(:meal)).to eq(meal)
  #   end
  # end
  #
  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Meal" do
  #       expect {
  #         post :create, {:meal => valid_attributes}, valid_session
  #       }.to change(Meal, :count).by(1)
  #     end
  #
  #     it "assigns a newly created meal as @meal" do
  #       post :create, {:meal => valid_attributes}, valid_session
  #       expect(assigns(:meal)).to be_a(Meal)
  #       expect(assigns(:meal)).to be_persisted
  #     end
  #
  #     it "redirects to the created meal" do
  #       post :create, {:meal => valid_attributes}, valid_session
  #       expect(response).to redirect_to(Meal.last)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved meal as @meal" do
  #       post :create, {:meal => invalid_attributes}, valid_session
  #       expect(assigns(:meal)).to be_a_new(Meal)
  #     end
  #
  #     it "re-renders the 'new' template" do
  #       post :create, {:meal => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end
  #
  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }
  #
  #     it "updates the requested meal" do
  #       meal = Meal.create! valid_attributes
  #       put :update, {:id => meal.to_param, :meal => new_attributes}, valid_session
  #       meal.reload
  #       skip("Add assertions for updated state")
  #     end
  #
  #     it "assigns the requested meal as @meal" do
  #       meal = Meal.create! valid_attributes
  #       put :update, {:id => meal.to_param, :meal => valid_attributes}, valid_session
  #       expect(assigns(:meal)).to eq(meal)
  #     end
  #
  #     it "redirects to the meal" do
  #       meal = Meal.create! valid_attributes
  #       put :update, {:id => meal.to_param, :meal => valid_attributes}, valid_session
  #       expect(response).to redirect_to(meal)
  #     end
  #   end
  #
  #   context "with invalid params" do
  #     it "assigns the meal as @meal" do
  #       meal = Meal.create! valid_attributes
  #       put :update, {:id => meal.to_param, :meal => invalid_attributes}, valid_session
  #       expect(assigns(:meal)).to eq(meal)
  #     end
  #
  #     it "re-renders the 'edit' template" do
  #       meal = Meal.create! valid_attributes
  #       put :update, {:id => meal.to_param, :meal => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   it "destroys the requested meal" do
  #     meal = Meal.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => meal.to_param}, valid_session
  #     }.to change(Meal, :count).by(-1)
  #   end
  #
  #   it "redirects to the meals list" do
  #     meal = Meal.create! valid_attributes
  #     delete :destroy, {:id => meal.to_param}, valid_session
  #     expect(response).to redirect_to(meals_url)
  #   end
  # end

end