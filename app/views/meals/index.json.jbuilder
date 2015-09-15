json.array!(@meals) do |meal|
  json.(meal, :id, :logged_at, :meal, :calories)
end
