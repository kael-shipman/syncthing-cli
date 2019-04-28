Syncthing CLI
====================================================================================

*A small but extensible bash-based cli for basic syncthing tasks*

## Introduction

I built this for the express purpose of being able to easily initiate a scan of a single directory from the command line. Thus, its one useful command at the time of this writing is `scan` (with the peripheral command `list-folders` also available). However, it can easily be extended to encompass more functionality, and I welcome PRs for any additional functionality that you might want to include (see [Contributing](#contributing) below).

I know there are already a few attempts at a Syncthing CLI afoot (including [syncthingmanager](https://github.com/classicsc/syncthingmanager) and possibly a mysterious and seemingly no-longer-developed [official syncthing cli](https://github.com/syncthing/syncthing-cli)), but I didn't find them very useful or easy to adapt, so I built this one instead.


## Usage

```
st ([global options]) [command] ([command options])
```

For a list of available commands, run `st list-commands`.

(More documentation on the way.)


## Contributing

### Scope

Core utilities within this CLI should map directly to simple API functions of Syncthing. My thought right now is that any complex functionality should be developed as a plugin (see [Plugins](#plugins) below). I respond fairly promptly, so please feel free to create an issue for any functionality you'd like to see and we can discuss it before you invest significant work in it. The worst case scenario, however, is that it just remains a plugin that you can continue to use personally.

Core commands should be written as functions with `snake_case` names. I prefer `kebab-case` for commands, so any `kebab-case` commands that are received are translated to their `snake_case` equivalents and used to call functions.

### Plugins

Plugins are simply other executables on the path whose name starts with `st-`. They may be written in any language, and my thought is that they will be used to accomplish more complex tasks. Plugins will have access to core functions and utility functions, as well as global caching variables like `_ST_FOLDER_IDS`, etc. (see source code for more).

#### API

In addition to core functions listed by calling `st list-commands | sed s/-/_/g`, the following internal utility functions are available to plugins:

```
##
# _set_csrf_token
#
# Sets the global CSRF token variables for use with future calls.
#
# @sets $_CSRF_TOKEN_NAME The name of the CSRF token to use as header name
# @sets $_CSRF_TOKEN The value of the CSRF token to use as header value
# @return void
##
```

```
##
# _get_http_body
#
# Parses the body out of an HTTP response
#
# NOTE: This is very inefficient. If anyone has a better way to do this, I would love to scrap
# this and use that instead.
#
# @param string $1 The full HTTP response
# @echo string The parsed-out body of the response
##
```

```
##
# _call
#
# Makes the specified API call
#
# @param "GET"|"PUT"|"PATCH"|"POST"|"DELETE" $1 The HTTP Method to use for the request
# @param string $2 The endpoint to target
# @param string|null $3 The body of the request
# @echo string|null The body of the response
##
```

#### Example

Here's an example of a very simple plugin that just gets folder statistics and dumps them in their native JSON:

```
#!/bin/bash

set -e

_call "GET" /rest/stats/folder
```

Note that this function depends on the availability of the `_call` method, meaning it won't work outside of being called by the native `st` command. It's good practice to check for the presence of the `$_ST_CONTEXT` variable (a boolean flag indicating that the script is being called in the context of the native `st` command) and alert accordingly if it is not found.


## Packaging

This codebase uses [peekaygee](https://github.com/kael-shipman/peekaygee) to manage its packages. See peekaygee documentation for more information. I use Xubuntu for my primary desktop, so the only package currently available is a Debian package, but I believe RPMs, Arch packages, and others should be easy to craft. Just add them under the `pkg-src` directory and feel free to submit PRs for those. I would be very appreciative :). You can build all packages (at least the ones you're set up to build (see peekaygee docs)) by running `peekaygee build`.

The latest debian package is currently available at https://packages.kaelshipman.me/. Instructions for adding the apt repo are there.


## To-Do

See [Issues](https://github.com/kael-shipman/syncthing-cli/issues) for all active issues.

