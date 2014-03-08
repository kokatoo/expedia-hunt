#!/bin/bash

echo "Running DB Dump"

cd /Users/jasonkok/ruby/expedia-hunt/

/Users/jasonkok/.rvm/gems/ruby-2.0.0-p247/bin/rake "db:data:dump"
git add db/data.yml
git commit -m "Add data.yml"
git push heroku master
heroku run rake db:data:load