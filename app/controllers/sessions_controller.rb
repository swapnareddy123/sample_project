class SessionsController < ApplicationController
  def login
  end
  def create
    user = User.authenticate(params[:email],params[:password])
    #if authorized_user && user.authenticate(params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to users_path ,:notice => "wow welcome again, you logged in as #{user.email}"
    else
      flash[:notice] = "invalid username or password"
      render "login"
    end
  end
  def destroy
    cookies.delete(:auth_token)
    redirect_to new_user_path , :notice => "successfully logged out"
  end
end
