express = require('express')
bodyParser = require('body-parser')
tw = require("./fetch_twitter")

app = express()
router = express.Router()

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use('/', router)
app.listen(18080)

router.route('/')
.get (req, res)->
  res.json({ message: 'root' })

router.route('/:screen_name/followers')
.get (req, res)->
  console.log(req)
  {screen_name} = req.params
  tw.getFollowers(screen_name)
  .then (all)-> res.json(all)
  .catch (err)->
    res.statusCode = 500
    res.send(500+"\n"+err)

router.route('/:screen_name/lists/:slug')
.get (req, res)->
  console.log(req)
  {screen_name, slug} = req.params
  tw.getListMember(screen_name, slug)
  .then (all)-> res.json(all)
  .catch (err)->
    res.statusCode = 500
    res.send(500+"\n"+err)
