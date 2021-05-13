class CommentsController < ApplicationController
    
    before_action :find_comment, only: [:destroy]

    def create
        @post = Post.find params[:post_id]
        @comment = Comment.new comment_params
        @comment.post = @post

        if @comment.save # Validate, if it passes validation then save it
            flash[:notice] = 'Successfully Created Comment'
            redirect_to post_path(@post)
        else
            flash[:danger] = @comment.errors.full_messages.join(', ')
            @comments = @post.comments.order(created_at: :desc)
            redirect_to post_path(@post)
            render 'posts/show'
        end
    end

    def destroy
        @comment.destroy
        redirect_to post_path(@comment.post_id)
    end

    private

    def find_comment
        @comment = Comment.find params[:id]
    end
end