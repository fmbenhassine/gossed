[![Go Report Card](https://goreportcard.com/badge/github.com/benas/gossed)](https://goreportcard.com/report/github.com/benas/gossed)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/benas/gossed.svg?branch=master)](https://travis-ci.org/benas/gossed)

# What is Gossed ?

<img align="right" src="gossed.png" width="140"/>

Gossed (Go Server Sent Events Daemon) is a small command-line tool written in go that turns data received on it's standard input into server sent events.

This makes it very easy to push data to browsers.

What data to push and how to interpret it in the browser is up to you.

# How to use it?

### With pre-built binary

First [download](https://github.com/benas/gossed/releases) `gossed` for your platform from and add it to your path.
Then, run it from a command line:

`$> gossed`

By default, `gossed` will start a server on port `3000` but you can specify a different port with `-port=YourPort` option.

### With Docker

The [benas/gossed](https://hub.docker.com/r/benas/gossed/) image contains all you need to run `gossed` in a docker container.

First, pull the image: `$> docker pull benas/gossed`

Then, you can start `gossed` in a docker container with: `$> docker run -i -p 3000:3000 benas/gossed`

# Examples

In the following examples, we assume you have `gossed` command either:

* in your PATH environment variable
* or as an alias for `docker run -i -p 3000:3000 benas/gossed`

### Hello world

`gossed` reads messages from STDIN and pushes them as server sent events. So let's first start a `gossed` process:

```shell
$> gossed
```

Now, every message written to the console will be pushed as a server sent event (on port 3000 by default, but you can change it if you want with `-port=YourPort`).
Here is a html page to consume these events:

```html
<!DOCTYPE html>
<html>
<head>
    <script type="text/javascript">
        var source = new EventSource("http://localhost:3000/");
        source.onmessage = function(event) {
            var content = document.getElementById('content');
            content.innerHTML = content.innerHTML + event.data + '<br/>';
        };
    </script>
</head>
<body>
    <div id="content"></div>
</body>
</html>
```

This file (in `examples/helloworld/index.html`) will print each event to the page content.
Open this file in a browser and type some messages in the console, you should see them in the web page:

![screenshot-helloworld](https://raw.githubusercontent.com/benas/ssed/master/examples/helloworld/screenshot.png)

This is the simplest example of how to use `gossed`. It's not really useful, but just to help you understand how it works.

Let see some other useful examples.

### Create a real time system monitoring dashboard

The following script (in `examples/system-stats/system-stats.sh)` gathers some statistics about system resources using the `top` command:

```shell
#!/usr/bin/env bash

CPU=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr '%' ' ')
MEMORY=$(top -l 1 | grep "PhysMem" | awk '{print $2}' | tr 'M' ' ')
PROCESSES=$(top -l 1 | grep "Processes" | awk '{print $2}')
THREADS=$(top -l 1 | grep "Processes" | awk '{print $10}')

echo "{\"cpu\": \"$CPU\", \"memory\": \"$MEMORY\", \"processes\": \"$PROCESSES\", \"threads\": \"$THREADS\"}";
```

Stats are written to the standard output in JSON format. Let's pipe them out to `gossed` every second:

```shell
$> while sleep 1; do system-stats.sh; done | gossed
```

Run this command and open the `examples/system-stats/index.html` file in a browser. You should see these charts with live data:

![screenshot-system-stats](https://raw.githubusercontent.com/benas/ssed/master/examples/system-stats/screenshot.png)

On the client side, server sent events are consumed and used to update charts:

```js
var source = new EventSource("http://localhost:3000/");
source.onmessage = function(event) {
    var data = JSON.parse(event.data);
    updateCharts(data);
};
```

As you can see, there is no need to create an additional server for the dashboard, just open the html file in a browser and you're done!

### Create a docker statistics dashboard

The following script (in `examples/docker/docker-stats.sh`) gathers some statistics about a running docker engine:

```shell
#!/bin/bash

IMAGES=$(docker images | wc -l);
RUNNING=$(docker ps --filter status=running | wc -l);
STOPPED=$(docker ps --filter status=exited | wc -l);

echo "{\"images\": \"$IMAGES\", \"running\": \"$RUNNING\", \"stopped\": \"$STOPPED\"}";
```

Stats are written to the standard output in JSON format. Let's pipe them out to `gossed` every 30 seconds:

```shell
$> while sleep 30; do docker-stats.sh ; done | gossed
```

We can now consume these stats in a web page:

```js
var source = new EventSource("http://localhost:3000/");
source.onmessage = function(event) {
    var data = JSON.parse(event.data);
    $('.images').text( data.images );
    $('.running').text( data.running );
    $('.stopped').text( data.stopped );
};
```

This snippet from `examples/docker/index.html` will parse data and show it in the following dashboard:

![screenshot-docker](https://raw.githubusercontent.com/benas/ssed/master/examples/docker/screenshot.png)

### Stream logs to the browser

The following command will push server logs to the browser:

```shell
$> tail -f server.log | gossed
```

Cool! we've just implemented [logio](http://logio.org/) :smile:

Try to run this command on a changing file in your system and open the `examples/helloworld/index.html` file in a browser.
You should see log events added in real time to the web page.

# Credits

* `gossed` is inspired by [websocketd](http://websocketd.com/).
* `gossed` uses [go-sse](https://github.com/alexandrevicenzi/go-sse) package to push server sent events to browsers.
* The system resources example above uses [smoothie charts](http://smoothiecharts.org) to render the live chart.

# License

`gossed` is released under the [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](http://opensource.org/licenses/MIT).

```
The MIT License (MIT)

Copyright (c) 2017 Mahmoud Ben Hassine (mahmoud.benhassine@icloud.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
