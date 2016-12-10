# About ssed

SSE daemon is a small command-line tool that turns data received on it's standard input into server sent events.
This makes it very easy to push data to browsers. What data to push and how to interpret it in the browser is up to you.

# How to use it?

### Using Node

`ssed` requires Node.js v4+. [Download](https://github.com/benas/ssed/releases) the latest release of `ssed` and run the following command: `$> node ssed.js` .

`ssed.js` is an executable script, you can also run it with: `$> ./ssed.js`

You may want to add `ssed` to your PATH or make an alias for it: `alias ssed='/path/to/ssed.js'`

By default, `ssed` will start a server on port 3000. You can specify a different port as first parameter: `node ssed.js 9000`

### Using Docker

The [benas/ssed](https://hub.docker.com/r/benas/ssed/) image contains all you need to run `ssed`.

First, pull the image: `$> docker pull benas/ssed`

Then, you can start `ssed` in a docker container: `$> docker run -i -p 3000:3000 benas/ssed`

# Examples

In the following examples, we assume you have `ssed` command either:

* in your PATH environment variable
* or as an alias for `node ssed.js`
* or as an alias for `docker run -i -p 3000:3000 benas/ssed`

### Hello world

`ssed` reads messages from STDIN and pushes them as server sent events. So let's first start a `ssed` process:

```shell
$> ssed
```

Now, every message written to the console will be pushed as a server sent event (on port 3000 by default, but you can change if you want).
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

This is the simplest example of how to use `ssed`. It's not really useful, but just to help you understand how it works.

Let see some other useful examples.

### Real time system monitoring dashboard

The following script (in `examples/system-stats/system-stats.sh)` gathers some statistics about system resources using the `top` command:

```shell
#!/usr/bin/env bash

CPU=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr '%' ' ')
MEMORY=$(top -l 1 | grep "PhysMem" | awk '{print $2}' | tr 'M' ' ')
PROCESSES=$(top -l 1 | grep "Processes" | awk '{print $2}')
THREADS=$(top -l 1 | grep "Processes" | awk '{print $10}')

echo "{\"cpu\": \"$CPU\", \"memory\": \"$MEMORY\", \"processes\": \"$PROCESSES\", \"threads\": \"$THREADS\"}";
```

Stats are written to the standard output in JSON format. Let's pipe them out to `ssed` every second:

```shell
$> while sleep 1; do system-stats.sh; done | ssed
```

Run this command and open the `examples/system-stats/index.html` file in a browser. You should see a chart with live data:

![screenshot-system-stats](https://raw.githubusercontent.com/benas/ssed/master/examples/system-stats/screenshot.png)

On the client side, server sent events are consumed and used to update charts:

```js
var source = new EventSource("http://localhost:3000/");
source.onmessage = function(event) {
    var data = JSON.parse(event.data);
    updateCharts(event.data);
};
```

As you can see, there is no need to create a server, just open the html file in a browser and you're done!

### Docker dashboard

The following script (in `examples/docker/docker-stats.sh`) gathers some statistics about a running docker engine:

```shell
#!/bin/bash

IMAGES=$(docker images | wc -l);
RUNNING=$(docker ps --filter status=running | wc -l);
STOPPED=$(docker ps --filter status=exited | wc -l);

echo "{\"images\": \"$IMAGES\", \"running\": \"$RUNNING\", \"stopped\": \"$STOPPED\"}";
```

Stats are written to the standard output in JSON format. Let's pipe them out to `ssed` every 10 seconds:

```shell
$> while sleep 10; do docker-stats.sh ; done | ssed
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
$> tail -f server.log | ssed
```

Cool! we've just implemented [logio](http://logio.org/) :smile:

Try to run this command on a changing file in your system and open the `examples/log/index.html` file in a browser.
You should see log events added in real time to the web page.

# Use cases

Now that you've got the idea, time to get your hands dirty! We can imagine any program _in any language_ that collects data on a regular interval,
write it to the standard output and pipe it out to `ssed`. Here are some ideas:

* display live Linux system stats (memory, CPU, IO, etc) in a pretty dashboard, just like [web-vmstats](https://github.com/joewalnes/web-vmstats)
* track data from a database: running for example `mysql -e 'SELECT COUNT(*) FROM orders'` every few minutes and make a live dashboard of it
* monitor Docker using [docker stats](https://docs.docker.com/engine/reference/commandline/stats/)
* monitor ElasticSearch using [node stats](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html)
* monitor MongoDB server using [mongo stats](https://docs.mongodb.com/v3.2/reference/method/db.stats/)
* etc

Your imagination is the limit!

# Contributions

You are welcome to contribute to the project with pull request on github.
I'm really bad at web design! All I know is importing twitter bootstrap css and js files in a html file.
If you can contribute an example of dashboard with cool widgets, I'll really appreciate your help! Many thanks upfront.

# Credits

* `ssed` is inspired by [websocketd](http://websocketd.com/)
* `ssed` uses [sse-node](https://www.npmjs.com/package/sse-node) module to push server sent events to browsers.
* The random numbers example above uses [smoothie charts](http://smoothiecharts.org) to render the live chart.

# License

`ssed` is released under the [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](http://opensource.org/licenses/MIT).

```
The MIT License (MIT)

Copyright (c) 2016 Mahmoud Ben Hassine (mahmoud.benhassine@icloud.com)

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
