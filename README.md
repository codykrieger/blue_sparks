BlueSparks
============

Epic static page rendering controller with support for nested pages.
Heavily inspired by [thoughtbot's high_voltage](/thoughtbot/high_voltage).

Static pages?
-------------

Yeah, like "About us", "Directions", marketing pages, etc.

Installation
------------

    % gem install bluesparks

Include in your Gemfile:

    gem "bluesparks"

Sorry, folks, Rails 3 only.

Usage
-----

Write your static pages and put them in the RAILS_ROOT/app/views/pages directory.

    % mkdir app/views/pages
    % touch app/views/pages/about.html.erb

<!--
After putting something interesting there, you can link to it from anywhere in your app with:

    link_to "About", page_path("about")

This will also work, if you like the more explicit style:

    link_to "About", page_path(:id => "about")
-->

Bam.

Routes
------

By default, the static page routes will be like /pages/:id (where :id is the view filename).

If you want to route to a static page in another location (for example, a homepage), do this:

    match 'pages/home' => 'bluesparks/pages#show', :id => 'home'

In that case, you'd need an app/views/pages/home.html.erb file.

Generally speaking, you need to route to the 'show' action with an :id param of the view filename.

You can route the root url to a high voltage page like this:

    root :to => 'bluesparks/pages#show', :id => 'home'

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

    class PagesController < HighVoltage::PagesController
      before_filter :authenticate
      layout :layout_for_page

      protected
        def layout_for_page
          case params[:id]
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
