class RegistrationsController < Devise::RegistrationsController

  before_filter :profile_completed, :load_user, only: :edit
  before_filter :ignore_blank_email,            only: :update

  def new
    @user = session[:auth_hash] ? User.new(session[:auth_hash][:user]) : User.new
    @activation_step = 1
  end

  def create
    @user = User.new params[:user].merge(social: !session[:auth_hash].nil?)
    if @user.save
      @user.authentications.create(session[:auth_hash][:authentication]) unless session[:auth_hash].nil?
      session[:auth_hash] = nil
      sign_in @user, bypass: true
      redirect_to root_path(mixpanel_signup: true)
    else
      flash[:error] = error_messages(@user)
      render :new
    end
  end

  def update
    @user = User.find current_user.id
    if @user.update_attributes(params[:user])
      sign_in @user, bypass: true
      redirect_to @user, flash: {success: t('flash.success.profile.updated')}
    else
      render :edit
    end
  end

  private

    def ignore_blank_email
      params[:user][:email] = nil if params[:user][:email].blank?
    end
end