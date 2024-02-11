class UsersController < ApplicationController
  def index
    
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  end

  def delete
    @user = User.find(params[:id])
  end

  def destroy
    @user = params[:id]
    User.find(params[:id]).destroy
    redirect_to '/admins/sign_in'
  end
end
