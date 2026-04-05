Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords"
    }

  root "pages#home"

  # Catch-all: serve the SPA for any unmatched GET request so React Router
  # can handle client-side navigation (must be last)
  get "*path", to: "pages#home", constraints: ->(req) { !req.xhr? && req.format.html? }
end
