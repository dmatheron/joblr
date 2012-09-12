class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  before_filter :set_locale
  before_filter :constrain_subdomain_path, if: :subdomain?

  private

    def set_locale
      I18n.default_locale = params[:locale] if !params[:locale].nil?
      I18n.locale = I18n.default_locale
    end

    def constrain_subdomain_path
      raise ActionController::RoutingError.new(t('errors.routing', path: request.path)) unless request.path == '/' || request.xhr?
    end

    def load_user
      unless subdomain?
        @user = params[:id] ? User.find(params[:id]) : current_user
      else
        unless multi_level_subdomain?
          @user = User.find_by_subdomain! request.subdomain
        else
          @user = User.find_by_subdomain! request.subdomains[0]
        end
      end
    end

    def not_signed_in
      redirect_to root_path, flash: {error: t('flash.error.only.public')} if user_signed_in?
    end

    def profile_completed
      unless signed_up?(@user)
        if user_signed_in?
          redirect_to edit_user_path(@user), flash: {error: t('flash.error.only.signed_up')}
        else
          raise ActionController::RoutingError.new(t('errors.routing', path: request.path))
        end
      end
    end

    def admin_user
      redirect_to root_path, flash: {error: t('flash.error.only.admin')} unless user_signed_in? && current_user.admin
    end

    def redirect_to_back(flash = {})
      redirect_to :back, flash
    rescue ActionController::RedirectBackError
      redirect_to root_path, flash
    end
end
