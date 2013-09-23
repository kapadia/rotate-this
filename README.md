
# Rotate This

## Getting Started

Make sure to install [Node](http://nodejs.org/), then run the following from the project directory.  Mongo must be installed, and running too.
    
    # Install Node dependencies (e.g. Express and Mongoose)
    npm install
    
    # Start mongo (probably want to do this in a separate terminal)
    mongod
    
    # Start app
    npm start

This starts a local server on port 8000.  The endpoint to get a random subject is

    /subjects

## Building Subjects
  
  cd data-import
  ruby builder.rb