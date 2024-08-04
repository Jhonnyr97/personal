class HomeController < ApplicationController
  caches_page :index, expires_in: 1.hour

  def index
  end
end
