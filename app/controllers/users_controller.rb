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
            render :new
        end

    end

    def update
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

end