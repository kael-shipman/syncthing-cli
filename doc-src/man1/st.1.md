% ST(1) Version ::VERSION:: | Bash-based CLI for Syncthing

NAME
====

**st** — A basic bash-based CLI for interacting with the Syncthing REST API

SYNOPSIS
========

| **st** \[**-p**|**--port** _port_] \[**-o**|**--host** _host_] _command_
| **st** \[**-h**|**--help**]
| **st** \[**-v**|**--version**]

DESCRIPTION
===========

Provides a basic but extensible CLI over Syncthing's native REST API. Comes loaded with a few
essential commands, but also provides a small framework for authoring plugins. Plugins have
access to the basic library functions detailed below in the `Plugins` section.

The essential built-in commands are the following:

status

:    Tells whether the underlying Syncthing API is running at the given host and port.

list-commands \[**-r**|**--raw**]

:    Lists all available commands, including plugins

     If the `-r|--raw` option is passed, outputs a `\n`-delimited list of command names with no
     extra text or whitespace.

list-folders \[**-i**|**--ids-only**]

:    Outputs a list of folders known to the Syncthing instance. Output format is as follows:

     [**folder id**] [**folder name**] [folder path]

     If the `-i|--ids-only` option is passed, only outputs ids.

scan [_folderid_[, _folderid..._]]

:    Scans the given folders, or scans all folders if no folders given. 


Global Options
--------------

-h, --help

:   Opens this man page

-o, --host _host_

:   Sets the hostname at which to find your syncthing API. Defaults to *localhost*.

-p, --port _port_

:   Sets the port at which to find your syncthing API. Defaults to *8384*.

-v, --version

:   Prints the current version number.


Plugins
-------

Plugins are very easy to develop, and there are no restrictions on what they can do (they don't
even have to do anything with syncthing, but of course they should).

To create a plugin, simply drop an executable file into the `$ST_PLUGIN_PATH` and rename it to
start with `st-`. That's it! `st` will make note of its existence in the native `list-commands`
command, and you can use it by calling `st [name-without-prefix]`. `st` will pass any unrecognized
arguments on to your plugin, and it will also export its own internal variables and functions for
use by your plugin. (If your plugin is in bash, it can use those functions natively. If not, you
may still be able to access them, depending on the capacities of the language you've chosen to
author your plugin in.

Regardless, `st` makes the following functions available to whomever chooses to use them:

_set_csrf_token

:    Sets the global CSRF token variables for use with future calls.

     * @sets $_CSRF_TOKEN_NAME The name of the CSRF token to use as header name
     * @sets $_CSRF_TOKEN The value of the CSRF token to use as header value
     * @return void



_get_http_body response_body

:    Parses the body out of an HTTP response

     NOTE: This is very inefficient. If anyone has a better way to do this, I would love to scrap
     this and use that instead.

     * @param string $1 The full HTTP response
     * @echo string The parsed-out body of the response

_call method endpoint [body]

:    Makes the specified API call

     * @param "GET"|"PUT"|"PATCH"|"POST"|"DELETE" $1 The HTTP Method to use for the request
     * @param string $2 The endpoint to target
     * @param string|null $3 The body of the request
     * @echo string|null The body of the response

Additionally, any core command can be called directly by simply replacing dashes with underscores.
For example, you may call `list_folders -i` from within a plugin and it will output a list of
available folder ids.


ENVIRONMENT
===========

**ST_PLUGIN_PATH**

:   The path at which syncthing cli plugins are stored. Defaults to `/usr/bin/`.

BUGS
====

See GitHub Issues: <https://github.com/kael-shipman/syncthing-cli/issues>

AUTHOR
======

See GitHub Contributors: <https://github.com/kael-shipman/syncthing-cli/graphs/contributors>

