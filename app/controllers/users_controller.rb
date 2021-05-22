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
            flash[:alert] = "Can not use current password"
            render :edit
        elsif @user&.authenticate(params[:user][:current_password])
            if @user.update user_params
                redirect_to edit_user_path, notice: "Profile successfully changed"
            else
                flash[:alert] = "Passwords did not match"
                render :edit
            end
        else
            flash[:alert] = "Current password incorrect"
            render :edit
        end
    end
        # @user = current_user
        # if @user&.authenticate(params[:current_password])
        #     new_password = user_params[:new_password]
        #     new_password_confirmation = user_params[:new_password_confirmation]
        #     new_password_is_distinct = new_password != user_params[:current_user]
        #     password_accept = new_password == new_password_confirmation

        #     if new_password_is_distinct && password_accept
        #         if @user.update password: new_password, password_confirmation: new_password_confirmation
        #             flash[:notice] = "Password changed successfully."
        #             redirect_to root_path
        #         else 
        #             flash[:danger] = @user.errors.full_messages.join(', ')
        #             render :edit_password
        #         end

        #     else
        #         flash[:danger] = @user.errors.full_messages.join(', ')
        #         render :edit_password
        #     end
        # else
        #     flash[:danger] = @user.errors.full_messages.join(', ')
        #     render :edit_password
        # end
    # end

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