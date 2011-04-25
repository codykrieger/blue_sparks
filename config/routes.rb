Rails.application.routes.draw do
  match '/*slug' => 'pages#show', :constraints => { :fullpath => /^\/(?!assets).+/ }
end
