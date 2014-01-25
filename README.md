# rails-lineman

Add this gem to your Gemfile if you want to deploy a lineman application with your
assets.

Wraps the `assets:precompile` rake task by building a specified lineman project.

All you need to set is a config property `Rails.application.config.rails_lineman.lineman_project_location` or environment variable $LINEMAN_PROJECT_LOCATION.

You may specify exactly what dist directories you want included through `Rails.application.config.rails_lineman.lineman_assets` or environment variable $LINEMAN_ASSETS.  Javascript and CSS are preprocessed, while any other folders- for example, img, are simply included in assets untouched.  Multiple folders are expressed as an array of Strings or Symbols.

From your templates you'll be able to require lineman-built JS & CSS like so:

``` erb
<%= stylesheet_link_tag "lineman/app" %>
<%= javascript_include_tag "lineman/app" %>
```

