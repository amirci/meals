class User < ActiveRecord::Base
  acts_as_token_authenticatable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable, 
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
end
