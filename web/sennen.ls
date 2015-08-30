require! {
    "lokijs": lokijs
    "../sennen.json": sennen_data 
    "./dispatcher/AppDispatcher": dispatcher
}

db = new lokijs
db.loadJSON JSON.stringify sennen_data
char = db.getCollection \char

