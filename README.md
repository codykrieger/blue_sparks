BlueSparks
============

Epic static page rendering controller with support for nested pages, and
routes at the root. Heavily inspired by [thoughtbot's high_voltage](/thoughtbot/high_voltage).

Routes at the root?
-------------------

Yeah, I'm talking about awesome routes like:

    /mypage

Instead of:

    /pages/mypage

Static pages?
-------------

Yeah, like "About us", "Directions", marketing pages, etc.

Installation
------------

    % gem install blue_sparks

Include in your Gemfile:

    gem "blue_sparks"

Sorry, folks, Rails 3 only.

Usage
-----

Write your static pages and put them in the RAILS_ROOT/app/views/pages directory.

    % mkdir app/views/pages
    % touch app/views/pages/about.html.erb

Here's the really cool part - _**you can nest pages**_.

    % mkdir app/views/pages/somefolder
    % touch app/views/pages/somefolder/index.html.erb
    % touch app/views/pages/somefolder/other.html.erb

Now you'll be able to go to /somefolder and /somefolder/other. You can
even nest these babies as deep as you like. Have a hundred folder
nesting if you want. AWESOME, RIGHT?!

<!--
After putting something interesting there, you can link to it from anywhere in your app with:

    link_to "About", page_path("about")

This will also work, if you like the more explicit style:

    link_to "About", page_path(:id => "about")
-->

Routes
------

By default, the static page routes will be like /:slug (where :slug is the view filename).

If you want to route to a static page in another location (for example, a homepage), do this:

    match '/home' => 'blue_sparks/pages#show', :slug => 'home'

In that case, you'd need an app/views/pages/home.html.erb file.

Generally speaking, you need to route to the 'show' action with an :slug param of the view filename.

You can route the root url to a high voltage page like this:

    root :to => 'blue_sparks/pages#show', :slug => 'home'

Which will render a homepage from app/views/pages/home.html.erb

Override
--------

Most common reasons to override?

  * You need authentication around the pages to make sure a user is signed in.
  * You need to render different layouts for different pages.

Create a PagesController of your own:

    $ rails generate controller pages

Override the default route:

    # in config/routes.rb
    resources :pages

Then modify it to subclass from High Voltage, adding whatever you need:

    class PagesController < BlueSparks::PagesController
      before_filter :authenticate
      layout :layout_for_page

      protected
        def layout_for_page
          case params[:slug]
          when 'home'
            'home'
          else
            'application'
          end
        end
    end

Testing
-------

Just a suggestion, but you can test your pages using Shoulda pretty easily:

    class PagesControllerTest < ActionController::TestCase
      tests PagesController

      %w(earn_money screencast about contact).each do |page|
        context "on GET to /#{page}" do
          setup { get :show, :slug => page }

          should_respond_with :success
          should_render_template page
        end
      end
    end

If you're not using a custom PagesController be sure to test <code>BlueSparks::PagesController</code> instead.

Enjoy!

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

for their awesome high_voltage gem.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

BlueSparks is Copyright © 2011 Cody Krieger. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
