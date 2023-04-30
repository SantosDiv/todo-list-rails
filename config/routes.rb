Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks do
    put "change_status", to: "tasks#change_status"
  end
end
