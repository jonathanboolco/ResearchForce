require 'sforce/rest/Chatter'

class UsersController < ApplicationController

  before_filter :authenticate, :only => [:show, :index, :edit, :update,:destroy]
  before_filter :validate_session, :only => [:show, :index, :edit, :update,:destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    
    @title = "All users"
    
    @users = User.paginate(:page => params[:page])
    @serviceauth = current_user.services.find(:first, :conditions => { :provider => 'forcedotcom' })
    
  end

  def show

    @user = User.find(params[:id])
    @serviceauth = current_user.services.find(:first, :conditions => { :provider => 'forcedotcom' })

    chatterService = Chatter.new(current_user)
    @userInfo = chatterService.get_users_info(@user.user_id)
    @title = @user.name

  end
      
  def new
    
    if signed_in?
      
      redirect_to current_user
      
    else
      
      @user = User.new
      @title = "Sign up"
      
    end
    
  end

  def create

    if signed_in?
      
      redirect_to(root_path)
      
    else
      
      @user = User.new(params[:user])
      
      if @user.save
        sign_in @user 
        flash[:success] = "Welcome to our Survey Service!"
        redirect_to @user
      else
        @title = "Sign up"
        render 'new'
      end
      
    end
    
  end

  def edit
    @title = "Edit user"
  end

  def update
    
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
    
  end

  def destroy
    
    destroyUser = User.find(params[:id])
    
    if(current_user.admin? && destroyUser == current_user)
      flash[:error] = "An admin user must be deleted by another user"
    else
      destroyUser.destroy
      flash[:success] = "User destroyed."
    end
    
    redirect_to users_path   
       
  end
    
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
