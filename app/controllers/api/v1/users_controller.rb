class Api::V1::UsersController < ApplicationController
     #only signup andlogin without authorization
     skip_before_action :authorized, only: [:create]

    def index
        user = User.all
        render json: user
    end

   
    def create
        user = User.create!(user_params)

        #if valid storing user_id in jwt token
        #encode_token method is defined in the application_controller
        token = encode_token({user_id: user.id})

        #sending along new user with jwt token
        #it will only render/dsplay back the new user and the jwt token 
        render json: {user: UserSerializer.new(user), jwt: token}, status: :created
    end

    def profile
        render json: @user
    end
    
    private

    def user_params
        params.require(:user).permit(:username, :password,:email)
    end
end
