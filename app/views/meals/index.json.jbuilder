json.array!(@meals) do |day_meals|
  json.extract! day_meals, :date, :calories
  json.meals day_meals.meals do |m|
    json.time     m.logged_at.strftime('%H:%M')
    json.meal     m.meal
    json.calories m.calories
  end
end
