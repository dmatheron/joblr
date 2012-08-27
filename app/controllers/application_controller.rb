class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  before_filter :set_locale
  before_filter :redirect_to_domain, if: :has_subdomain

  private

    def set_locale
      I18n.default_locale = params[:locale] if !params[:locale].nil?
      I18n.locale = I18n.default_locale
    end

    def redirect_to_domain
      if request.path != '/'
        redirect_to root_url(subdomain: request.subdomain), flash: { error: t('flash.error.subdomain.page') }
      end
    end

    def reset_devise_session
      session[:devise_controller] = nil if session[:devise_controller]
    end

    def find_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end

    def signed_up
      redirect_to(edit_user_path(@user), flash: {error: t('flash.error.only.member')}) unless signed_up?(@user)
    end

    def not_signed_in
      redirect_to root_path, flash: {error: t('flash.error.only.public')} if user_signed_in?
    end

    def admin
      redirect_to root_path, flash: {error: t('flash.error.only.admin')} if user_signed_in? && !current_user.admin
    end

    def redirect_to_back
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
end
