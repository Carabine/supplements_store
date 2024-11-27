class SessionsController < ApplicationController
  def new
    render :new
  end

   def create
     user = User.find_by(email: params[:email])

     Rails.logger.info "User found: #{@user.inspect}"

     if user&.authenticate(params[:password])
       session[:user_id] = user.id
       redirect_to root_path, notice: "Logged in successfully."
     else
       flash.now[:alert] = "Invalid email or password."
       respond_to do |format|
         format.html { render :new }
         format.turbo_stream { render turbo_stream: turbo_stream.replace('login_form', partial: 'sessions/form', locals: { user: user }) }
       end
     end
   end

    def destroy
      session.delete(:user_id)
      redirect_to root_path, notice: "Logged out successfully."
    end
end