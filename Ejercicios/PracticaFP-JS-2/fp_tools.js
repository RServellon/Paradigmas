//Tools para filtros
const not = f => p => !f(p)
const True = () => true
const False = not(True)
const and2 = (f1, f2) => p => f1(p) && f2(p)
const and = (...filters) => filters.reduce(and2, True)
const or2 = (f1, f2) => p => f1(p) || f2(p)
const or = (...filters) => filters.reduce(or2, filters.length > 0 ? False : True)

// Hacer or

const persons = [
    {firstname:'Jafeth', lastname:'Soto', id: 0, age:44, gender:'M'},
    {firstname:'Juan', lastname:'Perez', id: 1, age:53, gender:'M'},
    {firstname:'Maria', lastname:'Rodriguez', id: 2, age:23, gender:'F'},
    {firstname:'Sebastian', lastname:'Soto', id: 3, age:44, gender:'M'},
    {firstname:'Shakira', lastname:'Pik', id:4, age:47, gender:'F'}
]

const male = p => p.gender === 'M'
const adult = p => p.age >= 18
const female = not(male)
const startsWithLetterS = p => p.firstname.startsWith('S')
const startsWithLetterJ = p => p.firstname.startsWith('J')
const id = (p, id) => p.filter(x => x.id === id)

// console.log('>>>1',persons.filter(and(male,adult,startsWithLetterS)))
// console.log('>>>2',persons.filter(and(adult,startsWithLetterS)))
// console.log('>>>3',persons.filter(and()))
// console.log('>>>4',persons.filter(or2(male,startsWithLetterS)))
// console.log('>>>5',persons.filter(or(male,startsWithLetterJ, startsWithLetterS)))
// console.log('>>>6',persons.filter(or()))
console.log('>>>7', id(persons, 1))
