class PostsController < ApplicationController

    # Set up actions which will be executed first, before the CRUD actions. 
    before_action :find_post, only: [:edit, :update, :show, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize!, only: [:edit, :update, :destroy]
   
    # Now for the CRUD actions
    def new
        @post = Post.new
        @post.user = current_user
    end

    def create
        @post = Post.new post_params
        @post.user = current_user
        
        if @post.save # Validate, if it passes validation then save it
            flash[:notice] = 'New Post Successfully Created'
            redirect_to post_path(@post.id)
        else # Default to new method
            flash[:danger] = @post.errors.full_messages.join(', ')
            render :new
        end
    end

    def show  
        @comment = Comment.new
        @comments = @post.comments.order(created_at: :desc)  
        puts @comment
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
        flash[:notice] = 'Successfully Deleted Post'
        redirect_to root_path
    end

    private

    def find_post
        @post = Post.find params[:id]
    end

    def post_params
        params.require(:post).permit(
            :title,
            :body
        )
    end

    def authorize!
        redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, @post)
    end
end