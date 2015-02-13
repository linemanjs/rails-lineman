Rails-lineman
===
- [![Gem Version](https://badge.fury.io/rb/rails-lineman.png)](https://rubygems.org/gems/rails-lineman)

# Welcome to rails-lineman

This gem help you to deploy your rails application and lineman application easier.

It can use one of two deployed methods: 1) wraps the `assets:precompile` rake task by building a specified lineman project or 2) just copy js, css and html files from lineman application `dist` folder to a rails `public` folder.

# Installation
### Gemfile

Add `rails-lineman` to your Gemfile:

```ruby
gem 'rails-lineman'
```
And run Bundler:

```sh
$ bundle
```
# Usage
## Pointing at your lineman project

In `config/application.rb`, tell the gem where to find your Lineman project:

```ruby
config.rails_lineman.lineman_project_location = "some-directory"
```

You can also set an environment variable named `LINEMAN_PROJECT_LOCATION`

## Select deployment method
There are two possible methods: `:asset_pipeline` and `copy_files_to_public_folder`.So, tell the gem wich of two methods you want to use:
```ruby
config.rails_lineman.deployment_method = :copy_files_to_public_folder
```
# Deployment methods
## 1. By asset pipeline
Under this approach, an application's JavaScript & CSS would be built by lineman but would flow through the asset pipeline like any other asset in a Rails application.

### Pointing at multiple lineman projects
If you want to include multiple lineman projects, then you can provide a hash of logical names mapping to their path location.

```ruby
config.rails_lineman.lineman_project_location = {
  "my-app" => "app1",
  "admin-ui" => "app2"
}
```

The `LINEMAN_PROJECT_LOCATION` env variable will be ignored in this case, but you can of course bring your own like so:

```ruby
config.rails_lineman.lineman_project_location = {
  "my-app" => ENV['APP1_PATH'],
  "admin-ui" => ENV['APP2_PATH']
}
```

A hash configuration will result in your lineman assets being namespaced under "lineman/<app-name>", as opposed to at the root "lineman/" like they usually are. Keep this in mind when referencing your assets (e.g. you would need in this example to reference the second app's CSS as `<%= stylesheet_link_tag "lineman/admin-ui/app" %>`)

### Specifying asset types

By default, rails-lineman will only copy `dist/js` and `dist/css` from your Lineman
build to your Rails assets. To include other assets, like `dist/webfonts`, just add
them like so:

```ruby
config.rails_lineman.lineman_assets = [:webfonts, :css, :js]
```

You can also set an environment variable named `LINEMAN_ASSETS`

**Heads up:** if you add additional asset directories like above, you'll want to set up
the same directories as static routes for Lineman's development server. For example,
in your `config/application.js` file:

```js
//...
  server: {
    staticRoutes: {
      '/assets/webfonts': 'webfonts'
    }
  }
//...
```

### Referencing Lineman assets from your Rails views

From your templates you'll be able to require lineman-built JS & CSS like so:

``` erb
<%= stylesheet_link_tag "lineman/app" %>
<%= javascript_include_tag "lineman/app" %>
```
### Build environments that don't support node.js

Sometimes your existing deployment environment will support Ruby (because your
  app runs there), but will lack a proper Node.js runtime environment. In those
  cases, you may desire to cook up your own way to push the `dist` directory from
  your lineman application to your deployment server such that when *it* runs
  `rake assets:precompile` that the lineman assets will be in the proper place
  and copied at the appropriate moment despite not having been built on the actual
  server.

In cases like these, you may set:

```ruby
config.rails_lineman.skip_build = true
```

## 2. By copy files to public folder
Under this approach, lineman build  you client application on `dist/` and copy it into rails public folder. By default, rails-lineman will only copy `dist/css` and `dist/js` folder and `dist/index.html`. To include other asset see [here ](https://github.com/degzcs/rails-lineman#specifying-asset-types) and to include other html files, like `dist/another_index.html` just add them like so:

```ruby
config.rails_lineman.lineman_pages = [:index, :another_index ]
```

You can also set an environment variable named `LINEMAN_PAGES`
# License
* MIT, see the LICENSE file