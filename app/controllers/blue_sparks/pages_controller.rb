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

  def subnav
    # magic method to render a given folder's subnav partial
    begin
      subnav = render :partial => "#{current_page}/menu", :layout => "menu_template"
      subnav.first unless subnav.nil?
    rescue
      logger.info "subnav error: #{$!}"

      begin
        subnav = render :partial => "#{page_root}/menu", :layout => "menu_template"
      rescue
        logger.info "subnav error: #{$!}"
      end
    end
    logger.info "#{subnav.inspect}"
    subnav.first unless subnav.nil?
  end

protected

  def current_page
    "pages/#{params[:slug].to_s.downcase}"
  end

  def page_root
    "pages/#{params[:slug].to_s.downcase.gsub /^([^\/]+)(\/.+)+$/, '\1'}"
  end

end
