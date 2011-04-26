Rails.application.routes.draw do
  match '/*slug' => 'blue_sparks/pages#show', :constraints => { :fullpath => /^\/(?!assets).+/ }
end
