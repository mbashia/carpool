defmodule CarpoolWeb.Router do
  use CarpoolWeb, :router

  import CarpoolWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CarpoolWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CarpoolWeb do
    pipe_through :browser

    live "/", PageLive.Index, :index

    live "/image", ImageLive.Index, :index
    live "/image/new", ImageLive.Index, :new
    live "/image/:id/edit", ImageLive.Index, :edit

    live "/image/:id", ImageLive.Show, :show
    live "/image/:id/show/edit", ImageLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", CarpoolWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CarpoolWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", CarpoolWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", CarpoolWeb do
    pipe_through [:browser, :require_authenticated_user]
    live "/messages", MessageLive.Index, :index
    live "/messages/new", MessageLive.Index, :new
    live "/messages/:id/edit", MessageLive.Index, :edit

    live "/messages/:id", MessageLive.Show, :show
    live "/messages/:id/show/edit", MessageLive.Show, :edit

    live "/groups", GroupLive.Index, :index
    live "/groups/new", GroupLive.Index, :new
    live "/groups/:id/edit", GroupLive.Index, :edit

    live "/groups/:id", GroupLive.Show, :show
    live "/groups/:id/show/edit", GroupLive.Show, :edit

    live "/group_members", Group_memberLive.Index, :index
    live "/group_members/new", Group_memberLive.Index, :new
    live "/group_members/:id/edit", Group_memberLive.Index, :edit

    live "/group_members/:id", Group_memberLive.Show, :show
    live "/group_members/:id/show/edit", Group_memberLive.Show, :edit

    live "/group_messages", Group_messageLive.Index, :index
    live "/group_messages/new", Group_messageLive.Index, :new
    live "/group_messages/:id/edit", Group_messageLive.Index, :edit

    live "/group_messages/:id", Group_messageLive.Show, :show
    live "/group_messages/:id/show/edit", Group_messageLive.Show, :edit

    live "/trips", TripLive.Index, :index
    live "/trips/new", TripLive.Index, :new
    live "/trips/:id/edit", TripLive.Index, :edit

    live "/trips/:id", TripLive.Show, :show
    live "/trips/:id/addbooking", TripLive.Show, :addbooking
    live "/trips/:id/chat/:user_id", TripLive.Show, :chat
    live "/trips/:id/show/edit", TripLive.Show, :edit

    live "/bookings", BookingLive.Index, :index
    live "/bookings/new", BookingLive.Index, :new
    live "/bookings/:id/edit", BookingLive.Index, :edit

    live "/bookings/:id", BookingLive.Show, :show
    live "/bookings/:id/show/edit", BookingLive.Show, :edit

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", CarpoolWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
