require File.expand_path('../../lib/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  # Error pages
  match '/404', to: 'errors#error_404'
  match '/422', to: 'errors#error_422'
  match '/500', to: 'errors#error_500'

  devise_for :users, controllers: {omniauth_callbacks: 'authentifications', registrations: 'registrations'}

  resources :authentifications, only: [:destroy]
  resources :email_sharings,    only: [:create, :update] do
    get :already_answered
    get :decline
  end
  resources :beta_invites, except: :index do
    get :thank_you
    get :send_code
  end
  resources :users do
    resources :profiles
  end

  get  'users/auth/failure'  => 'authentifications#failure'
  post 'users/share_profile' => 'users#share_profile'

  match 'landing',                to: 'pages#landing'
  match 'admin',                  to: 'pages#admin'
  match 'style_tile',             to: 'pages#style_tile'

  # Subdomain constraints
  match '', to: 'users#show', constraints: Subdomain.new(true) || MultiLevelSubdomain.new(true)

  # Dynamic root_path
  root to: 'pages#landing', constraints: SignedIn.new(false)
  root to: 'users#edit',    constraints: SignedIn.new(true) && SignedUp.new(false)
  root to: 'users#show',    constraints: SignedIn.new(true) && SignedUp.new(true)

  # Preview of emails
  if Rails.env.development?
    mount EmailSharingMailer::Preview   => 'email_sharing_mailer'
    mount BetaInviteMailer::Preview     => 'beta_invite_mailer'
  end
end