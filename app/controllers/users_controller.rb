class UsersController < ApplicationController
    before_action :find_user, only: [:edit, :update, :edit_password, :update_password]
    before_action :authenticate_user!, only: [:edit, :update, :edit_password, :update_password]
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
            @user.errors.delete(:password) # This ensures that password-related errors don't
            # show redundantly when the user can't update them on this form in the first place

            flash[:notice] = @user.errors.full_messages.join(', ')
            render :edit
        end
    end

    def edit
    end

    def edit_password
    end

    def update_password
        @user=current_user
        if params[:user][:password] == params[:user][:current_password]
            flash[:danger] = "Cannot use current password."
            render :edit
        elsif @user&.authenticate(params[:user][:current_password])
            if @user.update user_params
                redirect_to edit_user_path, notice: "Password changed succesfully."
            else
                flash[:danger] = "Passwords did not match confirmation check, or may be too short."
                render :edit
            end
        else
            flash[:danger] = "Current password incorrect."
            render :edit
        end
    end


private

    def find_user
        @user = User.find params[:id]
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def authorize!
        unless can?(:crud, @user)
            flash[:danger] = 'Not Authorized' 
            redirect_to root_path
        end
    end
end