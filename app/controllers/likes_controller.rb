class LikesController < ApplicationController
  before_action :logged_in_user

  def create 
    @micropost = Micropost.find(params[:micropost_id])
    current_user.create_like(@micropost)
    redirect_to likes_user_path(current_user) #likeした投稿一覧ページへリダイレクト
  end

 def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.remove_like(@micropost)
    redirect_to :back 
 end
end