Rails.application.routes.draw do
  scope 'api/v1' do
    devise_for :users, skip: :all

    as :user do
      post 'sessions', to: 'v1/sessions#create'
    end

    resources :transactions, controller: "v1/transactions", only: [:create]
  end
end
