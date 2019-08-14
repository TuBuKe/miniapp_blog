class BlogsController < ApplicationController
  
  before_action :move_to_index, except: [:index, :show]
  
  def index
    @blogs = Blog.all.page(params[:page]).per(5).order("created_at DESC")
  end
  
  def new
    @blog = Blog.new
  end

  def show
  end

  def destroy
    blog = Blog.find(params[:id])
    if blog.user_id == current_user.id
      blog.destroy
    end
    redirect_to controller: :blogs, action: :index
  end

  def create
    Blog.create(create_params)
    redirect_to controller: :blogs, action: :index
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    @blog[:text] = params.require(:blog).permit(:text)[:text]
    @blog.save
    redirect_to controller: :blogs, action: :index
  end

  private
  def create_params
    params.require(:blog).permit(:text).merge(user_id: current_user.id)
  end 

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

end