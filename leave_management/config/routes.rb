Rails.application.routes.draw do
  devise_for :users

  resources :users, only:[:index] do
    collection do
      get :new_employees_list
      post :activate_employees_status
      get  :search_employees_data
      get  :all_employees_leaves_list
      post :approve_employees_leaves
      post :decline_employees_leaves
      get  :search_employees_leaves_status
      get  :new_leaves
    end
  end
  
  resources :leaves, only:[:new,:create,:index] do
    collection do
      get :error_leave
    end
  end


  root :to => redirect("/users/sign_in") # setting employees sign in (device) as root page
  
end
