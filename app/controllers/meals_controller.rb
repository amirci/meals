class MealsController < ApplicationController
  before_action :set_meal, only: [:update, :destroy]
  before_action :authenticate_user!
  # respond_to :json

  # GET /meals
  # GET /meals.json
  def index
    @meals = Meal.for_user(current_user).totals_by_date
  end

  # POST /meals.json
  def create
    @meal = Meal.new(meal_params)

    if @meal.save
      render :show, status: :created, location: api_v1_meal_url(@meal)
    else
      render json: @meal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /meals/1.json
  def update
    if @meal.update(meal_params)
      render :show, status: :ok, location: api_v1_meal_url(@meal)
    else
      render json: @meal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /meals/1.json
  def destroy
    @meal.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def set_meal
      @meal = Meal.find(params[:id])
    end

    def meal_params
      params.require(:meal).permit(:meal, :logged_at, :calories)
    end
end
