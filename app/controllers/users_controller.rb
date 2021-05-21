class UsersController < ApplicationController
    # before_action :find_user
    before_action :authenticate_user!, only: [:edit, :update]
    before_action :authorize!, only: [:edit, :update]

    def new
        @user=User.new
    end

    def create
        @user=User.new user_params
        if @user.save
            session[:user_id]=@user.id
            redirect_to root_path, notice: "Thank you for signing up!"
        else
            flash[:danger] = @user.errors.full_messages.join(', ')
            render :new
        end

    end

    def update
        if @user.update user_params
            flash[:success] = "Successfully Updated User Profile"
            redirect_to root_path
        else
            flash[:danger] = @user.errors.full_messages.join(', ')
            render :edit
        end
    end

    def edit
    end

    def update_password
    end

    def edit_password
    end

private

    def find_user
        @user = User.find params[:id]
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def authorize!
        redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, @post)
    end
end