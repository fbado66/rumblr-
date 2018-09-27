require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require_relative 'models'

set :sessions, true
use Rack::MethodOverride

def current_user
  if session[:user_id]
    User.find(session[:user_id])
  end
end


get '/' do
  erb :landing_page
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  user = User.create(
    username: params[:username],
    password: params[:password],
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    birthday: params[:birthday]
  );
  session[:user_id] = user.id
  flash[:info] = "Thank you for signing up #{user.first_name}"
  redirect '/my_page'

  if User.where(username: params[:username].downcase).present?
    flash[:alert] = "Username already exists, please try a different username."
    redirect '/sign_up'
  end

  if User.where(email: params[:email].downcase).present?
    flash[:alert] = "Email  already exists. please try a different email."
    redirect '/sign_up'
  end
end

get '/logout' do
  session[:user_id] = nil
    
    redirect '/'
end 

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do
  @username = params[:username]
  @password = params[:password]
  user = User.find_by(username: params[:username])
    if @username=="" or @password==""
      flash[:alert] = "credentials don't match our database"
      redirect 'sign_in'
    end 
    if user.nil?
      flash[:alert] = "It appears you are not in our database"
      redirect 'sign_in'
    end

     if user.password!= @password
      flash[:info] = "Password doesn't match our database."
      redirect '/sign_in'
    else
      session[:user_id] = user.id
      flash[:info] = "SIGNED IN AS #{user.username}."
      redirect '/my_page'
    end
  end 

get '/post_display' do
  user_id = session[:user_id]
  @user = User.find(user_id)
  @userpost = Userpost.all
  @all_post = @userpost.count
  @user = User.find_by(id: session[:user_id])
  @userpost = @user.userposts.reverse
  @current_post = @userpost.count
  erb :show_content
end 

post '/show_content' do
  @title = params[:title]
  @description= params[:description]
  @classification= params[:classification]

  Userpost.create(
    title: @title,
    description: @description,
    classification: @classification,
    user_id: session[:user_id])
  redirect 'creating_post'
end

get '/creating_post' do
  @userpost = Userpost.all
  @all_post = @userpost.count
  @user = User.find_by(id: session[:user_id])
  @userpost= @user.userposts.reverse
  @current_post= @userpost.count
  erb :show_content
end

get '/userpost' do
  @user = User.find_by(id: session[:user_id])
  @userpost= @user.userposts.reverse
  erb :userpost 
end 

get '/alluserposts' do
  @userpost = Userpost.last(20).reverse
  @all_post = @userpost.count
	erb :alluserposts 
end

get '/deleteaccount' do
  @user = User.find(session[:user_id])
  erb :deleteaccount
end

delete '/deleteaccount' do
  @user = User.find(session[:user_id])
  @user.destroy
  redirect '/logout'
end

get '/users' do
   @users = User.all
	 erb :users 
 end

get '/post_update' do
  @userpost = Userpost.all
 	@all_post= @userpost.count
 	@user = User.find_by(id: session[:user_id])
 	@userpost= @user.userposts
 	@current_post= @userpost.count
	erb :show_content
end

get '/deleteaccount' do
  @user = User.find(session[:user_id])
  @user.destroy
	if  session[:user_id]!=nil
		  session[:user_id]=nil
	end
  redirect '/'
end

get '/my_page' do
  erb :my_page
end 

get '/kill' do
  if session[:user_id]
    erb :kill
  else
  redirect '/'
  end
end

post "/kill" do
  @user = User.find(session[:user_id])
    if userpost = @user.userposts.find_by(id: params[:somethingelse])
       userpost.destroy
       flash[:alert] = "post was sucessfully destroyed"
       redirect '/userpost'
    else 
       flash[:alert] = "Id for the blog, was not found, please check again the id as for the blog you wish to kill"
       redirect '/userpost'
    end 
end 

post '/userposts' do
  Userpost.create(
    title: params[:title],
    description: params[:description]
  );
  redirect '/posts'
end



 


  




















