//Copy only not repeated documents to another database
function CopyDistinct(fromDB,fromColl,toDB,toColl){
    var numErrores = 0
    var numTotal = 0 
    var numInsert = 0
    var db = server.getDB(fromDB); 
	print("Conectamos con base de datos "+fromDB)
    var docsFrom = db[fromColl].find({});
    var db = server.getDB(toDB);
	print("Conectamos con base de datos "+toDB+ "para empezar a el merge")
    docsFrom.forEach(function(doc){
        var newDoc = db[toColl].findOne(doc._id);
        if(newDoc != null) {print("Objeto duplicado: "+doc._id);numErrores += 1;} 
        else {db[toColl].insert(doc); print("Objeto insertado: "+doc._id);numInsert += 1;} numTotal += 1; } );     
    print("Se han encontrado " + numErrores + " duplicados y se han insertado " + numInsert + " de " + numTotal + " Examinados");
}
