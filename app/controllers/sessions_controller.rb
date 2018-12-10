class SessionsController < ApplicationController

  def new
  end

  def create
    user=User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
# goes to sessions_helper - log_in
      log_in user
# goes to sessions_helper - remember / forget
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user


    else
      flash.now[:danger]='Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
