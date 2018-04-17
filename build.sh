#!/bin/bash


function makeHtml {
  cat <<EOF > $2
<!DOCTYPE HTML>
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$3</title>
  <link rel="shortcut icon" sizes="16x16 32x32 48x48 64x64 128x128 256x256" href="/favicon.ico">
  <link rel="stylesheet" href="/assets/style.css?v=4">
  <link rel="stylesheet" href="/assets/highlight/styles/default.css">
  <script src="/assets/highlight/highlight.pack.js"></script>
</head>

<body>

<script type="text/javascript">
$(cat $1)
var app = Elm.Main.fullscreen();
</script>

<script type="text/javascript">
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-25827182-1', 'auto');
ga('send', 'pageview');
</script>

</body>
</html>
EOF

}


## DOWNLOAD ELM BINARY

if [ ! -f bin/elm ]; then
  curl $ELM_URL | tar xz
  mkdir bin
  mv elm bin/
fi
PATH=$(pwd)/bin:$PATH


## GENERATE HTML

mkdir _temp

for elm in $(find src/pages -type f -name "*.elm"); do
    subpath="${elm#src/pages/}"
    name="${subpath%.elm}"

    js="_temp/$name.js"
    html="_site/$name.html"

    mkdir -p $(dirname $js)
    mkdir -p $(dirname $html)

    elm make $elm --optimize --output=$js
    # TODO minify the JavaScript
    makeHtml $js $html $name
done

rm -rf _temp