class Api::V1::UsersController < ApplicationController
    before_action :authorized, only: [:auto_sign_in]

    # REGISTER
    def sign_up
        user_exists = User.find_by(username: params[:username])
        if !user_exists
            @user = User.create(user_params)
            if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
            else
            render json: {error: "Error registering"}
            end
        else
            render json: {error: "User with this username already exists"}
        end
    end

    # LOGGING IN
    def sign_in
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
        else
        render json: {error: "Invalid username or password"}
        end
    end


    def auto_sign_in
        render json: @user
    end

    private

    def user_params
        params.permit(:username, :password)
    end
end
