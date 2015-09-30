Twit = require "twit"

T = new Twit require("./key_duxca.json")

getList = ->
  T.get "lists/list", {
    screen_name: "duxca"
  }, (err, data, response)->
    console.log(data)
    console.log(response)
    console.error(err)

getListMember = ->
  T.get "lists/members", {
    slug: "lv-3"
    count: 5000
    owner_screen_name: "duxca"
  }, (err, data, response)->
    tuples = data.users.map (a)-> a.screen_name
    console.log tuples
    console.log tuples.length
    #console.log response
    #console.error err

getListMember()
