defmodule ReadNeverWeb.Router do
  use ReadNeverWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ReadNeverWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReadNeverWeb do
    pipe_through :browser

    get "/", PageController, :home

    # books_directories
    live "/books_directories", BooksDirectoryLive.Index, :index
    live "/books_directories/new", BooksDirectoryLive.Index, :new
    live "/books_directories/:id/edit", BooksDirectoryLive.Index, :edit

    live "/books_directories/:id", BooksDirectoryLive.Show, :show
    live "/books_directories/:id/show/edit", BooksDirectoryLive.Show, :edit

    # books
    live "/books", BookLive.Index, :index
    live "/books/new", BookLive.Index, :new
    live "/books/:id/edit", BookLive.Index, :edit

    live "/books/:id", BookLive.Show, :show
    live "/books/:id/show/edit", BookLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReadNeverWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:read_never, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ReadNeverWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
