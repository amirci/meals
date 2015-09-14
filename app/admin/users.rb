ActiveAdmin.register Meal do
  
  
  permit_params :meal, :logged_at, :user_id, :calories

  filter :meal
  filter :logged_at
  filter :user_id
  filter :calories

  index do
    column :id
    column :user_id
    column :logged_at
    column :meal
    column :calories
    actions
  end

  form do |f|
    f.inputs 'Meal' do
      f.input :meal
      f.input :calories
      f.input :logged_at
    end
    f.actions
  end
end
