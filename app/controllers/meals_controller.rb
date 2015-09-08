class MealsController < ApplicationController
  before_action :set_meal, only: [:update, :destroy]

  # GET /meals
  # GET /meals.json
  def index
    @meals = Meal.totals_by_date
  end

  # POST /meals.json
  def create
    @meal = Meal.new(meal_params)

    if @meal.save
      render :show, status: :created, location: @meal
    else
      render json: @meal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /meals/1.json
  def update
    respond_to do |format|
      if @meal.update(meal_params)
        format.json { render :show, status: :ok, location: @meal }
      else
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
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
