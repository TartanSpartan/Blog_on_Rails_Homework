class CommentsController < ApplicationController
    
    before_action :find_comment, only: [:destroy]
    before_action :authenticate_user!
    before_action :authorize!, only: [:destroy]

    def create
        @post = Post.find params[:post_id]
        @comment = Comment.new comment_params
        @comment.user = current_user
        @comment.post_id = params[:post_id]

        if @comment.save # Validate, if it passes validation then save it
            flash[:notice] = 'Successfully Created Comment'
            redirect_to post_path(@comment.post_id)
        else
            flash[:danger] = @comment.errors.full_messages.join(', ')
            @comments = @post.comments.order(created_at: :desc)
            render 'posts/show'
        end
    end

    def destroy
        @comment.destroy
        flash[:notice] = 'Successfully Deleted Comment'
        redirect_to post_path(@comment.post_id)
    end

    private

    def find_comment
        @comment = Comment.find params[:id]
    end
    
    def comment_params
        params.require(:comment).permit(:body, :id)
    end

    def authorize!
        unless can?(:crud, @comment)
            flash[:danger] = 'Not Authorized' 
            redirect_to root_path
        end
    end
end