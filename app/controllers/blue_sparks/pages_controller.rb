class BlueSparks::PagesController < ApplicationController

  unloadable

  rescue_from ActionView::MissingTemplate do |exception|
    if exception.message =~ %r{Missing template pages/}
      raise ActionController::RoutingError, "No such page: #{params[:slug]}"
    else
      raise exception
    end
  end

  def show
    begin
      render :template => current_page
    rescue
      raise $! unless $!.kind_of? ActionView::MissingTemplate

      render :template => "#{current_page}/index"
    end
  end

protected

  def current_page
    "pages/#{params[:slug].to_s.downcase}"
  end

  def page_root
    "pages/#{params[:slug].to_s.downcase.gsub /^([^\/]+)(\/.+)+$/, '\1'}"
  end

end
