class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    #before executing any public action needs to be authorized
    before_action :authorized

     

    #defining the encode_token response that will encode our secret_key 
    #secret_key is your personal password
     def encode_token(payload)
        JWT.encode(payload, "secret_key")
     end

     def auth_header
        #Authorization: Bearer folsoa.adsdsd.aadsf
        #grabbing the header from the request object will return  the authorization
        request.headers["Authorization"] 
     end


     def decoded_token
        #if true we are grabbing the token from the request object will return the current user 
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                #decoding the token from the secret key
                JWT.decode(token,"secret_key", true, algorithm: 'HS256')
            rescue
                nil
            end
        end
     end

     def current_user
        if decoded_token #if nil is passed to logged_in
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
     end


     def logged_in?
        !!current_user
     end

     #checking the authorization if user has logged in
     def authorized
        if logged_in?
            true
        else
            render json: { message: "Please login!"}, status: :unauthorized
        end
     end







   
    private
   
      def render_unprocessable_entity(invalid)
           render json:{errors: invalid.record.errors}, status: :unprocessable_entity
    end
   
    def render_not_found(error)
           render json:{errors: {error.model => "Not Found"}}, status: :not_found
      end
end
