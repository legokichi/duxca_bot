express = require('express')
morgan = require('morgan')
bodyParser = require('body-parser')
cors = require('cors')
tw = require("./fetch_twitter")

app = express()
router = express.Router()
_cors = cors({origin: 'http://duxca.com'})
app.options('*', _cors)
app.use(morgan("dev", { immediate: true }))
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use('/', express.static('htdocs'))
app.use('/', router)
app.listen(8081)

router.route('/:screen_name/followers')
.get _cors, (req, res)->
  {screen_name} = req.params
  tw.getFollowers(screen_name)
  .then (all)-> res.json(all)
  .catch (err)->
    res.statusCode = 500
    res.json({statusCode: 500, message: err})

router.route('/:owner_screen_name/lists/:slug')
.get _cors, (req, res)->
  {owner_screen_name, slug} = req.params
  tw.getListMember(owner_screen_name, slug)
  .then (all)-> res.json(all)
  .catch (err)->
    res.statusCode = 500
    res.json({statusCode: 500, message: err})

router.route('/:owner_screen_name/lists/:slug/add')
.get _cors, (req, res)->
  {owner_screen_name, slug} = req.params
  {screen_names} = req.query
  screen_names = screen_names.split(/\s*,\s*/)
  tw.addListMember(owner_screen_name, slug, screen_names)
  .then (all)-> res.statusCode = 204; res.send()
  .catch (err)->
    res.statusCode = 500
    res.json({statusCode: 500, message: err})


router.route('/:owner_screen_name/lists/:slug/remove')
.get _cors, (req, res)->
  {owner_screen_name, slug} = req.params
  {screen_names} = req.query
  screen_names = screen_names.split(/\s*,\s*/)
  tw.removeListMember(owner_screen_name, slug, screen_names)
  .then (all)-> res.statusCode = 204; res.send()
  .catch (err)->
    res.statusCode = 500
    res.json({statusCode: 500, message: err})
