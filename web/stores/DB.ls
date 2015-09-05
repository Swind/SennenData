require! {
    "lokijs": lokijs
    "../../sennen.json": sennen_data 
}

# Import all char to lokijs for searching
db = new lokijs
char_db = db.addCollection \char

for item in sennen_data
    char_db.insert item

module.exports = char_db
