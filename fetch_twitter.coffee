Twit = require "twit"
T = new Twit require "./key_duxca.json"

getListMember = (owner_screen_name, slug)->
  new Promise (resolve, reject)->
    T.get "lists/members", {
      slug, owner_screen_name, count: 5000
    }, (err, data, response)->
      return reject err if err?
      ret = data.users.map (user)->
        {id, screen_name, name, profile_image_url, description} = user
        {id, screen_name, name, profile_image_url, description}
      resolve ret

getFollowers = do ->
  getFrends = (screen_name)->
    new Promise (resolve, reject)->
      T.get "friends/ids", {screen_name, count: 5000}, (err, data, response)->
        return reject err if err?
        ret = data.ids
        resolve ret

  getUsersLookup = (user_ids)->
    new Promise (resolve, reject)->
      T.get "users/lookup", {user_id: user_ids.join(",")}, (err, data, response)->
        return reject err if err?
        ret = data.map (user)->
          {id, screen_name, name, profile_image_url, description} = user
          {id, screen_name, name, profile_image_url, description}
        resolve ret

  splitWithN = (arr, n)->
    arr.reduce(((lst, elm, i)->
      if i%n is 0
      then lst.push([elm])
      else lst[lst.length-1].push(elm)
      lst
    ), [])
  (user_name)->
    getFrends(user_name).then (ids)->
      splitWithN(ids, 100).reduce(((prev, ids)->
        prev.then (all)->
          getUsersLookup(ids).then (lst)-> all.concat(lst)
      ), Promise.resolve([]))

addListMember = (owner_screen_name, slug, screen_names)->
  new Promise (resolve, reject)->
    T.post "lists/members/create_all", {owner_screen_name, slug, screen_name:screen_names.join(",")}, (err, data, response)->
      return reject err if err?
      ret = data
      resolve ret

removeListMember = (owner_screen_name, slug, screen_names)->
  new Promise (resolve, reject)->
    T.post "lists/members/destroy_all", {owner_screen_name, slug, screen_name:screen_names.join(",")}, (err, data, response)->
      return reject err if err?
      ret = data
      resolve ret

module.exports = {
  getListMember
  getFollowers
  addListMember
  removeListMember
}
