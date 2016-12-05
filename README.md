# About ssed

SSE deamon is a small command-line tool that turns data received on it's standard input into server sent events.
This makes it very easy to push data to browsers. What data to push and how to interpret it in the browser is up to you.

`ssed` is inspired by the great [websocketd](http://websocketd.com/) by [@joewalnes](https://twitter.com/joewalnes) but it's quite different:
 it does not wrap an existing command, it just reads messages from the standard input and push them as server sent events.

# How to use it?

`ssed` requires node js and npm. To install `ssed`, run the following commands:

```shell
$>git clone https://github.com/benas/ssed.git
$>cd ssed
$>npm install
```

You can run `ssed` using `node ssed.js` or by making `ssed.js` executable:

```shell
$>chmode +x ssed.js
$>./ssed.js
```

You may want to add `ssed` to your PATH or make an alias for it: `alias ssed='/path/to/ssed.js'`

By default, `ssed` will start a server on port 3000. You can specify a different port as first parameter: `node ssed.js 9000`

# Example: plot some random numbers

The following command writes random numbers to the standard output every second.
These numbers can be piped out to `ssed` and rendered in a real time chart:

```shell
while sleep 1; do echo $[ ( $RANDOM % 100 )  + 1 ]; done | ssed
```

Run this command and open the `examples/random/index.html` file in a browser. You should see a chart with live data:

![screenshot](https://raw.githubusercontent.com/benas/ssed/master/examples/random/screenshot.png)

On the client side, we need to listen to server sent events and update the chart:

```js
var source = new EventSource("http://localhost:3000/");
source.onmessage = function(event) {
    updateChart(event.data);
};
```

As you can see, there is no need to create a server, just open the html file in a browser and you're done.

# Use cases

Now that you've got the idea, time to get your hands dirty! We can imagine any program that collects data on a regular interval,
write it to the standard output and pipe it out to `ssed`. Here are some examples:

* display live Linux system stats (memory, CPU, IO, etc) in a pretty dashboard, just like [web-vmstats](https://github.com/joewalnes/web-vmstats)
* create a monitoring dashboard of running docker containers (cpu usage, memory consumption, etc) using [docker stats](https://docs.docker.com/engine/reference/commandline/stats/) command
* track data from a Mysql database (or any other db): running for example `mysql -u USER -p PWD -e 'SELECT COUNT(*) FROM orders' eshop` every x seconds and make a live dashboard of it
* monitor ElasticSearch nodes using [node stats](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html) command
* etc

# Contributions

You are welcome to contribute to the project with pull request on github.
I'm really bad at web design! All I know is importing twitter bootstrap css and js files in a html file.
If you can contribute an example of dashboard with cool widgets, I'll really appreciate your help! Many thanks upfront.

# Credits

*`ssed` uses [sse-node](https://www.npmjs.com/package/sse-node) module to push server sent events to browsers.
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
