mirror-core Cookbook
====================

This cookbook provide a definition for an Apache-hosted mirror, with the mirror command run as a task service.

Requirements
============

Platform
--------

* Ubuntu 13.04 (that's all we support at /dev/fort for now, so that's all I've tested.)

Recipes
=======

This cookbook contains no recipes.

Definitions
===========

mirror
------

Manage an Apache `web\_app` (using the `apache2` cookbook) and services to ensure the requested command runs until it returns 0.

Each mirror creates two services, `#{params['name']}_mirror`, an [Upstart task job](http://upstart.ubuntu.com/cookbook/#task-job) responsible for running the command and restarting until it returns 0, and `#{params['name']}_mirror_shim`, an [Upstart abstract job](http://upstart.ubuntu.com/cookbook/#abstract-job) which exists to start the task job without blocking.

### Parameters:

* `name` - The name of the content to mirror. This writes to `#{node['apache']['dir']}/sites-available/#{params['name']}.conf` for the Apache virtualhost, and `/etc/init/#{params['name']}_mirror.conf` and `/etc/init/#{params['name']}_mirror_shim.conf` for the services.
* `target` - The path at which mirrored content should be hosted.
* `command` - Command to run to mirror the required content.
* `cwd` - Optional. The directory in which to run the mirror command.
* `web_app_template` - Default `web_app.conf.erb`, Apache config file.
* `task_template` - Default `mirror_task.conf.erb`, Upstart config for mirror task.
* `shim_template` - Default `mirror_shim.conf.erb`, Upstart config for mirror shim.
* `cookbook` - Optional. Cookbook where the source templates are. If
  this is not defined, Chef will use the named template in the
  cookbook where the definition is used. Suggested value: `mirror-core`.
* `user` - User to own the mirrored content and execute the mirror task.
* `hostname` - VirtualHost name for this content
* `port` - Port to listen on for this mirror's VirtualHost.
