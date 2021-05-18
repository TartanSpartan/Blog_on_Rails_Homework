class PostsController < ApplicationController

    # Set up actions which will be executed first, before the CRUD actions. 
    # Do not need to do user handling until the Week 7- Authentication assignment.
    # So will cut those for now.
    before_action :find_post, only: [:edit, :update, :show, :destroy]
   
    # Now for the CRUD actions
    def new
        @post = Post.new
    end

    def create
        @post = Post.new post_params
        
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
        redirect_to posts_path
    end

    private

    def post_params
        params.require(:post).permit(
            :title,
            :body
        )
    end

    def find_post
        @post = Post.find params[:id]
    end

end