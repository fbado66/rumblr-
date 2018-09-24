require 'sinatra/activerecord'
require 'pg'

set :database, 'postgresql:tumblr'


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