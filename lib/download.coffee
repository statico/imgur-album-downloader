#!/usr/bin/env coffee

require 'shelljs/global'

async = require 'artillery-async'
needle = require 'needle'
fs = require 'fs'
commander = require 'commander'
{inspect} = require 'util'
{extname} = require 'path'

commander
  .arguments('<client-id> <album-id> <output-dir>')
  .parse(process.argv)

get = (path, cb) ->
  url = "https://api.imgur.com/3#{ path }"
  options =
    json: true
    headers:
      Authorization: "Client-ID #{ clientId }"
  needle.get url, options, cb

commander.help() unless commander.args.length is 3
[clientId, albumId, outputDir] = commander.args

mkdir '-p', outputDir

get "/album/#{ albumId }", (err, res) ->
  if err?
    console.error "Request failed: #{ err }"
    exit 1
  if res.statusCode != 200
    console.error "Fetching the album returned #{ res.statusCode }"
    exit 1

  async.forEachSeries res.body.data.images, (item, cb) ->

    url = item.link
    exts = ['link']
    exts.unshift('webm') if item.bandwidth > 1024*1024*2 # Grab webms for big GIFs
    for e in exts
      url = item[e]
      break if url?
    return cb("No image in #{ inspect item }") unless url?

    filename = (item.title or item.id).replace(/[^\w]+/g, '-') + extname(url)
    console.log url, '->', filename
    path = "#{ outputDir }/#{ filename }"

    stream = fs.createWriteStream path
    needle.get(url).pipe(stream)
      .on 'error', cb
      .on 'close', ->
        fs.utimesSync path, item.datetime, item.datetime
        console.log 'done' 
        cb()

  , (err) ->
    console.error "FAILED: #{ err }" if err?
