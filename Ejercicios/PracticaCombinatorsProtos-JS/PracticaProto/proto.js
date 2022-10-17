const {default: Stream} = await import('../combinators/combinators.mjs');


class A {
    constructor(x) {
        this.x = x
    }
}

class B extends A {
    constructor(x, y) {
        super(x)
        this.y = y
    }
}

function proto_level(o) {
    let contador = 0
    protoActual = o.__proto__
    while(protoActual) {
        protoActual = protoActual.__proto__
        contador++
    }
    return contador
}

function proto_level_stream(o) {
     return Stream.iterate(o, e => e = e.__proto__)
     .toList().length
}

let a = new A(333)
console.log('Proto a nivel 1: ' +  a.__proto__)
console.log('Proto a nivel 2: ' +  a.__proto__.__proto__)
console.log('Proto a nivel 3: ' +  a.__proto__.__proto__.__proto__ )
console.log('Cantidad total de protos de a: ' + proto_level(a) + '\n')

let b = new B(111, 666)
console.log('Proto b nivel 1: ' +  b.__proto__)
console.log('Proto b nivel 2: ' +  b.__proto__.__proto__)
console.log('Proto b nivel 3: ' +  b.__proto__.__proto__.__proto__ )
console.log('Proto b nivel 4: ' +  b.__proto__.__proto__.__proto__.__proto__)
console.log('Cantidad total de protos de b: ' + proto_level(b) + '\n')

console.log('Prueba proto stream: ' + proto_level_stream(a))
console.log('Prueba proto stream: ' + proto_level_stream(b))

