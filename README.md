# ssed

SSE deamon is a small command-line tool that turns data received on it's standard input into server sent events.
This makes it very easy to push data to browsers in a generic way.

`ssed` is inspired by the great [websocketd] by [@joewalnes](https://twitter.com/joewalnes) but is quite different:
it does not wrap an existing command, it just reads messages from the standard input and push them as server sent events.
This makes it easy to pipe data to `ssed` from any program that writes to the standard output.
