class UsersController < ApplicationController
  def index
    
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end
end
