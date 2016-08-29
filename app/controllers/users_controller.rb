class UsersController < ApplicationController
before_action :correct_user,   only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
    @all_users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user 
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
  if @user.update(user_params)
      redirect_to @user, notice: 'ユーザー情報をアップデートしました'
  else
      render 'edit'
  end
  end

def followings
    @user  = User.find(params[:id])      
    @followings = @user.following_users  
end

def followers 
    @user  = User.find(params[:id])
    @followers = @user.follower_users
end

def likes
  @user = User.find(params[:id])
  @feed_likes = @user.like_microposts.order(created_at: :desc)
  render 'likes/feed_likes'
end


 def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.remove_like(@micropost)
    redirect_to :back 
 end

  def index
  @all_users = User.order("created_at")
  end
  
  def all_users
    User.all
  end
  
  
  private
def correct_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless @user == current_user
end

def user_params
  #userハッシュの定義
  params.require(:user).permit(:name, :email, :password, :age, :profile,
                               :password_confirmation)
end

end

