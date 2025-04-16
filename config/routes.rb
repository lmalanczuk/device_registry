Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope '/api' do
    post :assign, to: 'devices#assign'
    post :unassign, to: 'devices#unassign'
  end
end
