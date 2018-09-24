require 'sinatra/activerecord'
require 'pg'

configure :development do
set :database, 'postgresql:tumblr'
end 

configure :production do
  set :database, ENV["DATABASE_URL"]
end 


class User < ActiveRecord::Base
  # has_many :posts, :dependent => :delete_all
  has_many :userposts, dependent: :destroy
end

class Userpost < ActiveRecord::Base
  belongs_to :user
end



# class Post < ActiveRecord::Base
#   belongs_to :user
# end