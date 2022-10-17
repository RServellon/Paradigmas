import {cousins}  from  './oop.mjs'

class A{ 
   toString(){return this.constructor.name}
}
class B extends A{}
class C extends A{}
class D extends B{}
var b = new B()
var c = new C()



console.log(`*** Version A: cousins(${b}, ${c}) = ${cousins(b, c)} ***`)
console.log()