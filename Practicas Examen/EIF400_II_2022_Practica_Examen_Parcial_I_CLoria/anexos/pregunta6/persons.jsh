import com.google.gson.*;
import com.google.gson.reflect.*;

// Utils para personas
enum Gender{MALE, FEMALE}

record Person(String name, Gender gender, int age){}

var gen = new Random(666);
int genAge(){return Math.abs(gen.nextInt())%120;}
String genName(){return names.get(Math.abs(gen.nextInt())%names.size());}
String genFamilyName(){return familyNames.get(Math.abs(gen.nextInt())%familyNames.size());}
String genFullName(){ return genName() + " " + genFamilyName();}
Gender genGender(){return gen.nextBoolean() ? Gender.MALE : Gender.FEMALE;}

var names = Arrays.asList(  
   "Ana", "Bernardo", "Carlos", 
   "Diego","Diana", "Enrique", 
   "Fernanda", "Gabriela", "Hanna",
   "Jorge", "Jose", "Alberto",
   "Juan", "Lorenzo", "Diego"

);
var familyNames = Arrays.asList(  
   "Perez", "Rodriguez", "Hernandez", 
   "Herrera","Salas", "Solis", 
   "Arias", "Gomez", "Gonzalez",
   "Ramirez", "Herrera", "Marin",
   "Soto", "Brenes", "Sanchez",
   "Mora", "Coto", "Chin", "Bermudez"

);
List<Person> genPersons(int n){ 
    return IntStream.range(0, n).mapToObj(i -> new Person(genFullName(), genGender(), genAge())).toList();
   
}
final String PERSONS_JSON_FILE = "persons.json";
void writePersons(int n) throws Exception{
    var writer = new FileWriter(PERSONS_JSON_FILE);
    var format = "{\"name\":\"%s\", \"gender\":\"%s\", \"age\":%d}";
   
    var persons = genPersons(n);
    var output =
    persons.stream()
           .map (p -> String.format(format, p.name(), p.gender(), p.age()))
           .collect(Collectors.joining(",", "[", "]"));
           
    writer.write(output);
    writer.close();
}



enum AgeClass {INFANT, CHILD, TEEN, ADULT, ELDER}
AgeClass classify(Person p){
    int age = p.age();
    if(age < 2) return AgeClass.INFANT;
    if(age < 11) return AgeClass.CHILD;
    if(age < 20) return AgeClass.TEEN;
    if (age < 65) return AgeClass.ADULT;
    return AgeClass.ELDER;
}

//
class PersonClass{
    public String name;
    public Gender gender;
    public int age;
    public PersonClass(String name, Gender gender, int age){
        this.name = name;
        this.gender = gender;
        this.age = age;
    }
    public static Person toPerson(PersonClass pc){ return new Person(pc.name, pc.gender, pc.age);}
    public static PersonClass fromPerson(Person p){
        return new PersonClass(p.name(), p.gender(), p.age());
    }
    public String toString(){
        return String.format("PersonClass(%s, %s, %d)", name, gender, age);
    }
    
}

List<Person> readPersonsJSON() throws Exception{
    String json = Files.lines(Paths.get(PERSONS_JSON_FILE))
                               .collect(Collectors.joining(""));
    var gson = new Gson();
    var collectionType = new TypeToken<List<PersonClass>>(){}.getType();                           
    List<PersonClass> persons = gson.fromJson(json, collectionType);
    return persons.stream().map(PersonClass::toPerson).toList();
                   
}