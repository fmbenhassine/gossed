#!/usr/bin/env node

/*
 * MIT License
 *
 * Copyright (c) 2017 Mahmoud Ben Hassine (mahmoud.benhassine@icloud.com)
 * Source: https://github.com/benas/ssed
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

const readline = require('readline');
const sse = require("sse-node");
const app = require("express")();
const rl = readline.createInterface({
  input: process.stdin
});

var clients = [];

rl.on('line', (input) => {
  clients.forEach(function(client) {
    client.send(input);
  });
});

app.all('/', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
 });

app.get("/", (req, res) => {
    const client = sse(req, res);
    clients.push(client);
    client.onClose(() => {
    	var index = clients.indexOf(client);
    	if (index > -1) {
    		clients.splice(index, 1);
		}
    });
});

app.listen(process.argv[2] || 3000);
