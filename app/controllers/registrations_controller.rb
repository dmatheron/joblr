class RegistrationsController < Devise::RegistrationsController

  before_filter :ignore_blank_email, only: :update

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      sign_in @user, bypass: true
      redirect_to @user, flash: {success: t('flash.success.profile_updated')}
    else
      render :edit
    end
  end

  private

    def ignore_blank_email
      params[:user][:email] = nil if params[:user][:email].blank?
    end
end