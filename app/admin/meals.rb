ActiveAdmin.register User do

  permit_params :email, :calories, :password, :password_confirmation

  filter :email
  filter :last_sign_in_at
  filter :created_at
  filter :updated_at

  index do
    column :id
    column :email
    column :calories
    column :admin
    column :last_sign_in_at
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs 'Info' do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.inputs 'Role' do
      f.input :admin, label: 'Administrator'
    end
    f.inputs 'Config' do
      f.input :calories
    end
    f.actions
  end
end
