class ApplicationController < ActionController::Base
  require "tasks/payment_time"
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_notification
  before_action :set_locale
  before_action :load_support_messages
  before_action :load_notification_admin
  before_action :user_blocked?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, alert: exception.message
  end
  include PublicActivity::StoreController
  include GeneralHelper

  around_action :skip_bullet

  def skip_bullet
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = true
  end

  def load_notification
    if user_signed_in?
      @notifications = Notification.by_receiver(current_user).newest
      @count_notification_unread = @notifications.unread.size
    end
  end

  def load_notification_admin
    if admin_signed_in?
      @notifications_admin = Notification.by_receiver(current_admin).limit(Settings.notification.limit).newest
      @count_notification_unread_admin = @notifications_admin.unread.size
    end
  end

  def after_sign_out_path_for resource
    return new_admin_session_path if resource == :admin
    return root_path if resource == :user
  end

  def after_sign_in_path_for resource
    return admin_root_path if resource.class.name == Admin.name
    return venues_path if resource.class.name == User.name
  end

  def load_support_messages
    if user_signed_in?
      @support = current_user.supports.build
      @supports = current_user.supports.all
      @user_unread = current_user.supports.user_unread.count
    end
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "admin.users.user_not_found"
      redirect_to root_path
    end
  end

  def find_user_by_params_user_id
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:danger] = t "admin.users.user_not_found"
      redirect_to root_path
    end
  end

  def make_read_all_supports unread_supports
    unread_supports.each do |support|
      support.update_attributes is_read: true
    end
  end

  private
  def set_locale
    save_session_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def save_session_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_in, keys: [:name, :email]
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :email,
      :password, :password_confirmation]
    devise_parameter_sanitizer.permit :account_update,
      keys: [:name,:email, :password, :password_confirmation,
      :current_password, :bio, :company, :position, :skill,
      :phone_number, :facebook, :google, :twitter]
  end

  def user_blocked?
    if current_user.present? && current_user.blocked?
      sign_out current_user
      flash[:danger] = t "flash.user_blocked"
      redirect_to root_path
    end
  end

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end
end
