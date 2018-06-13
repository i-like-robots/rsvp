Rails.application.routes.draw do
  namespace :admin do
    resources :guests
    resources :notifications

    # custom action routes
    get 'notifications/:id/send', to: "notifications#send_to_all", as: 'send_to_all_notification'
    get 'notifications/:id/test', to: "notifications#send_test", as: 'send_test_notification'

    root to: "guests#index"

  end

  get 'rsvp', to: 'rsvp#index'
  post 'rsvp', to: 'rsvp#submit'
  patch 'rsvp', to: 'rsvp#submit'
  get 'rsvp/confirm', to: 'rsvp#confirm'
  get 'rsvp/verify', to: 'rsvp#verify'
  get 'rsvp/success', to: 'rsvp#success'

  get 'guest', to: 'guest#login'
  post 'guest', to: 'guest#submit'
  get 'guest/confirm', to: 'guest#confirm'
  post 'guest/confirm', to: 'guest#verify'
  get 'guest/profile', to: 'guest#profile'
  post 'guest/profile', to: 'guest#update'
  patch 'guest/profile', to: 'guest#update'
  get 'guest/logout', to: 'guest#logout'
end
