express = require "express"
mongoose = require "mongoose"

app = express()

app.use( express.bodyParser() )

# mongoose.connect(process.env.MONGOHQ_URL)
mongoose.connect('mongodb://localhost/rotate_this')
db = mongoose.connection

SubjectScheme = new mongoose.Schema({
  id: 'string',
  location: 'string',
  type: 'string',
  random: 'number'
})
Subject = mongoose.model('Subject', SubjectScheme)

ClassificationScheme = new mongoose.Schema({
  id: 'string',
  subject1: 'string',
  subject2: 'string',
  slowSubject: 'string'
})
Classification = mongoose.model("Classification", ClassificationScheme)

# Subject.find({random: {"$gt": Math.random}}).sort("random").limit(1)[0]

app.get('/subjects', (req, res) ->
  Subject.find({random: {"$gt": Math.random()}}).sort("random").limit(1).execFind( (err, subject) ->
    res.json(subject)
  )
)

app.post("/classification", (req, res) ->
  c = req.body
  console.log "CLASSIFICATION", c
  
  classification = new Classification({
    subject1: c.subject1,
    subject2: c.subject2,
    slowSubject: c.slowSubject
  })
  classification.save()
  res.json(true)
)

app.use( express.static(__dirname) )
app.listen(process.env.PORT || 8000)