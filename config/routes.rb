Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "user/omniauth_callbacks" }
  get 'staticpages/home'
  root 'staticpages#home'
end
