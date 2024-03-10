# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy like comment]
  before_action :set_post, only: %i[show destroy like comment]

  def index
    @posts = if user_signed_in?
               Post.order(Arel.sql("CASE WHEN user_id = #{current_user.id} THEN 1 ELSE 2 END, created_at DESC"))
             else
               Post.order(created_at: :desc)
             end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if current_user == @post.user
      @post.destroy
      redirect_to posts_path, notice: 'Post was successfully destroyed.'
    else
      redirect_to posts_path, alert: 'You are not authorized to destroy this document.'
    end
  end

  def like
    if current_user.likes.where(post: @post).exists?
      redirect_to @post, alert: 'You have already liked this post.'
    else
      like = current_user.likes.build(post: @post)
      if like.save
        redirect_to @post, notice: 'Post liked successfully.'
      else
        redirect_to @post, alert: 'Failed to like the post.'
      end
    end
  end

  def comment
    @post = Post.find(params[:id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'Comment added successfully.'
    else
      render :show
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :media)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
