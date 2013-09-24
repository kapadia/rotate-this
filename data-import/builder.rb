require 'mongo'
include Mongo

@location = "http://ubret.s3.amazonaws.com/rotate-this"

# Read files from disk
fast_files = Dir["subjects/atlas_jpegs/fast/*.jpg"]
slow_files = Dir["subjects/atlas_jpegs/slow/*.jpg"]

# Connect to Mongo
mongo_client = MongoClient.new("localhost", 27017)
db = mongo_client.db("rotate_this")

# Drop subject collection
db.drop_collection("subjects")

# Create subject collection
col = db.collection("subjects")

# Create subjects
fast_files.each do |f|
  basename = File.basename f
  doc = {
    location: "#{@location}/#{basename}",
    random: Random.rand(),
    type: "fast"
  }
  col.insert(doc)
end

slow_files.each do |f|
  basename = File.basename f
  doc = {
    location: "#{@location}/#{basename}",
    random: Random.rand(),
    type: "slow"
  }
  col.insert(doc)
end

# Create classification collection
db.collection("classifications")

# # col.ensureIndex({random: 1})