class MealsController < ApplicationController
  before_action :set_meal, only: [:update, :destroy]
  before_action :authenticate_user!
  # respond_to :json

  # GET /meals
  # GET /meals.json
  def index
    @meals = Meal.for_user(current_user)
  end

  # POST /meals.json
  def create
    @meal = current_user.meals.build(meal_params)

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
    if @meal.destroy
      render :show, status: :ok
    else
      render json: @meal.errors, status: :unprocessable_entity
    end
  end

  private
    def set_meal
      @meal = Meal.for_user(current_user).find(params[:id])
    end

    def meal_params
      params.require(:meal).permit(:meal, :logged_at, :calories)
    end
end
