json.array!(@meals) do |meal|
  json.extract! meal, :id, :meal, :logged_at, :calories
end
