class Api::V1::UsersController < ApplicationController
    before_action :authorized, only: [:auto_sign_in]

    # REGISTER
    def sign_up
        user_exists = User.find_by(username: params[:username])
        if !user_exists
            @user = User.create(user_params)
            if @user.valid?
            exp = Time.now.to_i + 4 * 3600
            token = encode_token({user_id: @user.id, exp: exp})
            render json: {user: @user, token: token}
            else
            render json: {error: "Error creating a new user"}
            end
        else
            render json: {error: "User with this username already exists"}
        end
    end

    # LOGGING IN
    def sign_in
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
        exp = Time.now.to_i + 4 * 3600
        token = encode_token({user_id: @user.id, exp: exp})
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
