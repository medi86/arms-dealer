Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  get 'staticpages/home'
  root 'staticpages#home'
end
