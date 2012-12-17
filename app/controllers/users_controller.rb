class UsersController < ApplicationController
  before_filter :authenticate_user, except: [:new, :create, :login]

  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to locations_url, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to locations_url, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def login
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user && user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        redirect_to locations_path, :notice => "You are now logged in!"
      else
        flash.now[:error] = "Invalid email or password."
        @user = User.new
        respond_to do |format|
          format.html
        end
      end
    else
      @user = User.new
      respond_to do |format|
        format.html
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url, :notice => "You are now logged out."
  end
end