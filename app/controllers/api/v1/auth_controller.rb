class Api::V1::AuthController < ApplicationController
    #only signup andlogin without authorization
    skip_before_action :authorized, only: [:create]

    #grab password and username and compare it with the input params to authenticate
    def create
        @user = User.find_by(username: login_params[:username])
        # if @user && @user.password == login_params[:password]
        if @user && @user.authenticate(login_params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: UserSerializer.new(@user), jwt: token}, status: :accepted
        else
            render json: { message: "Invalid password/username"},status: :unauthorized
        end
    end

    private

    def login_params
        params.require(:user).permit(:username,:password)
    end


end