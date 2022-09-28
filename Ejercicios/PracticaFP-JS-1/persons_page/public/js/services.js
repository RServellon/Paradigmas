/**
* Simulates a web service yielding persons
@author loricarlos@gmail.com
@version demo

*/
import data from '../json/persons.json' assert {type: 'json'};

const Gender = {
    MALE: 2,
    FEMALE: 4
}

const Age = {
    ALL: {inf: 0, sup: 100},
    CHILD: {inf: 0, sup: 11},
    TEENAGER: {inf: 12, sup: 20},
    ADULT: {inf: 21, sup: 64},
    SENIOR: {inf: 65, sup: 100},
}

class Person{
    static #id_counter = 0;
    #id;
    #firstname;
    #lastname;
    #age;
    #gender;
    constructor(firstname, lastname, age, gender){
        [this.#firstname, this.#lastname, this.#age, this.#gender] =
        [firstname, lastname, age, gender]
        this.#id = Person.#id_counter++
    }
    get id(){return this.#id}
    get firstname(){return this.#firstname}
    get lastname(){return this.#lastname}
    get age(){return this.#age}
    get gender(){return this.#gender}
    toObj(){
        return {
            id: this.id,
            firstname: this.firstname,
            lastname: this.lastname,
            age: this.age,
            gender: this.gender == Gender.MALE ? "M" : "F"
        }
    }
}

const delayFunction = d => d % 1000 * 1000

export function get_persons(url = "/person", delay = 3) {
    return new Promise(then =>
        setTimeout(() => then(JSON.stringify(persons.map((p) => p.toObj()))), delayFunction(delay)))
  }


const persons = data.persons.map(p => new Person(p.firstname, p.lastname, p.age, p.gender).toObj())

// Tools para filtros
const not = f => p => !f(p)
const True = () => true
const False = not(True)
const and2 = (f1, f2) => p => f1(p) && f2(p)
const and = (...filters) => filters.reduce(and2, True)
const or2 = (f1, f2) => p => f1(p) || f2(p)
const or = (...filters) => filters.reduce(or2, filters.length > 0 ? False : True)

// Filtros
const ageRange = r => p => p.age >= r.inf && p.age <= r.sup
const id = id => p => id === '' ? True : p.id === parseInt(id)
const male = p => p.gender === 'M'
const female = not(male)
const startsWithXLetter = letter => p => letter === 'all' ? True : p.firstname.startsWith(letter)

const allAges = new Map([
    ['all', ageRange(Age.ALL)],
    ['child', ageRange(Age.CHILD)],
    ['teenager', ageRange(Age.TEENAGER)],
    ['adult', ageRange(Age.ADULT)],
    ['senior', ageRange(Age.SENIOR)]
])

const allGenders = new Map([
    ['all', True],
    ['male', male],
    ['female', female]
])

// Unificación de filtros    
export function get_persons_by_selection(URI="/persons", queryOptions, delay = 3){   
    return new Promise(then =>
            setTimeout(() =>
                then(persons
                    .filter(and(allAges.get(queryOptions.ageSelected), allGenders.get(queryOptions.genderSelected), 
                    startsWithXLetter(queryOptions.letterSelected), id(queryOptions.idSelected)), 
            delayFunction(delay))
            )
        )
    )
}


