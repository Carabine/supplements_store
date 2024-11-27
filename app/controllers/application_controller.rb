class ApplicationController < ActionController::Base
  before_action :set_render_cart
  before_action :initialize_cart
  helper_method :current_user, :user_signed_in?, :admin_user?

  def set_render_cart
    @render_cart = !(controller_name == 'sessions' && action_name == 'new')
  end

  def initialize_cart
    @cart ||= Cart.find_by(id: session[:cart_id])

    if @cart.nil?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def admin_user?
    current_user&.admin?
  end

  def authenticate_admin!
    redirect_to root_path, alert: "You must be an admin to access this section." unless admin_user?
  end
end