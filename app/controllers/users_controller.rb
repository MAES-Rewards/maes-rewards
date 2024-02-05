class UsersController < ApplicationController
  def index
    @users = User.order(:name)
  end

  def show
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
