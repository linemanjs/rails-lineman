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

### Pointing at multiple lineman projects

If you want to include multiple lineman projects, then you can provide a hash of logical names mapping to their path location.

```
config.rails_lineman.lineman_project_location = {
  "my-app" => "app1",
  "admin-ui" => "app2"
}
```

The `LINEMAN_PROJECT_LOCATION` env variable will be ignored in this case, but you can of course bring your own like so:

```
config.rails_lineman.lineman_project_location = {
  "my-app" => ENV['APP1_PATH'],
  "admin-ui" => ENV['APP2_PATH']
}
```

A hash configuration will result in your lineman assets being namespaced under "lineman/<app-name>", as opposed to at the root "lineman/" like they usually are.

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

## Build environments that don't support node.js

Sometimes your existing deployment environment will support Ruby (because your
  app runs there), but will lack a proper Node.js runtime environment. In those
  cases, you may desire to cook up your own way to push the `dist` directory from
  your lineman application to your deployment server such that when *it* runs
  `rake assets:precompile` that the lineman assets will be in the proper place
  and copied at the appropriate moment despite not having been built on the actual
  server.

In cases like these, you may set:

```
config.rails_lineman.skip_build = true
```
