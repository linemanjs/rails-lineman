# rails-lineman

Add this gem to your Gemfile if you want to deploy a lineman application with your
assets.

Wraps the `assets:precompile` rake task by building a specified lineman project.

## Pointing at your lineman project

In `config/application.rb`, tell the gem where to find your Lineman project:

```
config.rails_lineman.lineman_project_location = "some-directory"
```

You can also set an environment variable named `LINEMAN_PROJECT_LOCATION`

## Specifying asset types

By default, rails-lineman will only copy `dist/js` and `dist/css` from your Lineman
build to your Rails assets. To include other assets, like `dist/webfonts`, just add
them like so:

```
config.rails_lineman.lineman_assets = [:webfonts, :css, :js]
```

You can also set an environment variable named `LINEMAN_ASSETS`

**Heads up:** if you add additional asset directories like above, you'll want to set up
the same directories as static routes for Lineman's development server. For example,
in your `config/application.js` file:

```
//...
  server: {
    staticRoutes: {
      '/assets/webfonts': 'webfonts'
    }
  }
//...
```

## Referencing Lineman assets from your Rails views

From your templates you'll be able to require lineman-built JS & CSS like so:

``` erb
<%= stylesheet_link_tag "lineman/app" %>
<%= javascript_include_tag "lineman/app" %>
```

