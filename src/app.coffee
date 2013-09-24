express = require "express"
mongoose = require "mongoose"
Q = require "q"

app = express()
app.use( express.bodyParser() )

# mongoose.connect(process.env.MONGOHQ_URL)
mongoose.connect(process.env.MONGOHQ_URL || 'mongodb://localhost/rotate_this')
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
  selected: 'string',
  expert_id: 'string',
  expert_name: 'string'
})
Classification = mongoose.model("Classification", ClassificationScheme)

app.get("/gettwo", (req, res) ->
  
  dfd1 = Q.defer()
  dfd2 = Q.defer()
  subjects = []
  r = Math.random()
  
  Q.all([dfd1.promise, dfd2.promise]).then( ->
    res.json(subjects)
  )
  
  Subject.find({type: 'slow', random: {"$gt": Math.random()}}).sort("random").limit(1).execFind( (err, subject) ->
    index = if r < 0.5 then 0 else 1
    
    s = {}
    subject = subject[0]
    unless subject?
      subjects[index] = s
      dfd1.resolve()
    
    for key in ["_id", "location", "random"]
      s[key] = subject[key]
    
    subjects[index] = s
    dfd1.resolve()
  )
  Subject.find({type: 'fast', random: {"$gt": Math.random()}}).sort("random").limit(1).execFind( (err, subject) ->
    index = if r < 0.5 then 1 else 0
    
    s = {}
    subject = subject[0]
    unless subject?
      subjects[index] = s
      dfd2.resolve()
    
    for key in ["_id", "location", "random"]
      s[key] = subject[key]
    
    subjects[index] = s
    dfd2.resolve()
  )
)

app.post("/classification", (req, res) ->
  c = req.body
  
  classification = new Classification({
    subject1: c.subject1,
    subject2: c.subject2,
    selected: c.selected,
    expert_id: c.expert_id,
    expert_name: c.expert_name
  })
  classification.save()
  res.json(true)
)

app.use( express.static(__dirname) )
app.listen(process.env.PORT || 8000)