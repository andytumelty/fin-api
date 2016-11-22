class UsersController < ApplicationController
  before_action :authenticate, except: [:create]

  # GET /user
  def show
    render json: @current_user
  end

  # POST /user
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user
  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: @current_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user
  def destroy
    @current_user.destroy
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
