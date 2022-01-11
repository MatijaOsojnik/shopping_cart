class ApplicationController < ActionController::API
    def encode_token(payload)
        JWT.encode(payload, Rails.application.credentials.dig(:jwt, :jwt_secret_key), 'HS256')
    end

    def auth_header
        # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
    end

    def decoded_token
        if auth_header
        token = auth_header.split(' ')[1]
        # header: { 'Authorization': 'Bearer <token>' }
        begin
            JWT.decode(token, Rails.application.credentials.dig(:jwt, :jwt_secret_key), true, algorithm: 'HS256')
        rescue JWT::DecodeError
            #Logout user
            render json: { error: "Token expired." }
            return true
        end
        end
    end

    def current_user
        if decoded_token
        user_id = decoded_token[0]['user_id']
        @user = User.select(:id, :username, :name, :surname, :email, :phone).find_by_id(user_id)
        end
    end

    def logged_in?
        !!current_user
    end

    def authorized
        render json: { error: 'You are not authorized for this action' }, status: :unauthorized unless logged_in?
    end

    #AWS CSV upload 

    def parse_user_cart_report
        CSV.open("path/to/file.csv", "wb") do |csv|
            csv << Cart.attribute_names
            user = User.find_by_id(user_id) 
            csv << user.attributes.values
        end     
    end

    def read_user_cart_report
        #TO be written later
    end
end
