/open persons.jsh
List<Person> persons = readPersonsJSON();
Optional<List<Person>> oldestWomen(List<Person> persons) throws Exception{
    //TO DO
    return null;
}

var oldest = oldestWomen(persons)
println("*** Version A: Listing oldest women ***");
if ( oldest.isPresent() ){
   oldest.get().forEach( woman -> println(woman) );
} else {
    println("No oldeswoman exists");
}