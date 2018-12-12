class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

# Paginate will automatically generate params[:page] from will_paginate in layout index.html.erb
  def index
    @users=User.paginate(page: params[:page])
  end

  def show
    @user=User.find(params[:id])
    @microposts=@user.microposts.paginate(page: params[:page])
    #debugger
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)
    if @user.save
# send_activation_email is method in user.rb
      @user.send_activation_email
      flash[:info]= "Please check ypur email to activate your account"
      redirect_to root_url
    else
       render 'new'
    end
  end

  def edit
    # @user=User.find(params[:id]) # Calling corrent_user before actions has
    # already defined @user variable, no need to redefine it there
  end

  def update
    # @user=User.find(params[:id]) # The same as above
    if @user.update_attributes(user_params)
      flash[:success]="Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User deleted"
    redirect_to users_url
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Filters before Action



  # Confirms the right user for Edit and Update methods on users page
  def correct_user
    @user=User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
