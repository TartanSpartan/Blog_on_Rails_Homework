class PostsController < ApplicationController

    # Set up actions which will be executed first, before the CRUD actions
    before_action :find_post, only: [:edit,: update, :show, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize!, only: [:edit, :update, :destroy]

    # Now for the CRUD actions
    def new
        @idea = Idea.new
    end

    def create
        @post = Post.new post_params
        @post.user = current_user
        if @post.save # Validate, if it passes validation then save it
            flash[:notice] = 'New Post Sucessfully Created'
            redirect_to post_path(@post.id)
        else # Default to new method
            render :new
        end
    end

    def show  
        @comment = Comment.new
        @comments = @post.comments.order(created_at: :desc)  
    end

    def index
        @posts = Post.order(created_at: :desc)
    end

    def edit
    end
    
    def update
        if @post.update post_params # Validate, if it passes validation then update it
            flash[:notice] = 'Successfully Updated Post'
            redirect_to post_path(@post.id)
        else # Default to edit method
            render :edit
        end
    end


    def destroy
        @post.destroy
        redirect_to posts_path
    end

    private

    def post_params
        params.require(:post).permit(
            :title,
            :description
        )
    end

    def find_post
        @post = Post.find params[:id]
    end

    def authorize!
        redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, @post)
    end

end