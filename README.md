# imgur-album-download

Quick and dirty script to download an Imgur image album to a directory.

GIFs over 2 MB are downloaded as WebM. That probably seems like a weird decision.

## Usage: Command Line

[Register an Imgur application](https://api.imgur.com/oauth2/addclient) of type "Anonymous usage" and copy the Client ID. Then:

```
$ npm install -g imgur-album-download

$ imgur2rss <client-id> <album-id> <output-dir>
http://i.imgur.com/uS30Q4P.webm -> infinite-falling-down.webm
done
http://i.imgur.com/bIsGhVF.webm -> taylor-swift-cat.webm
done
```
