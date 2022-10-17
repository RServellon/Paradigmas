
function* fnats() {
    let n = 0
    while(true) {
        yield n
        n++
    }
}

function* ffilter(iter, f) {
    for(let x of iter) {
        if ( f(x) ) yield x
    }
}

function* fmap(iter, f) {
    for(let x of iter) {
        yield f(x)
    }
}

function* flimit(iter, max) {
    let i = 0
    for(let x of iter) {
        if (i >= max) break
        yield x
        i++
    }
}


function* fiterate(initial, delta) {
    let x = 0
    while(delta(initial)){
        x = delta(initial)
        initial = x
        yield x
    }
}

function* ffindFirst(iter, f) {
    let i = 0
    for(let x of iter) {
        if (f(x)) {
            yield x
            break
        }
        i++
    }
}


// naturals = fnats()
// //Pares
// even = ffilter(naturals, x => x % 2 == 0)
// //Cuadrados
// squared = fmap(naturals, x => x ** 2)
// // Limite
// nat10 = flimit(naturals, 10)

// even_from_nat10 = ffilter(nat10, x => x % 2 == 0)

export default class Stream {
    constructor(iter) {
        this.iter = iter
    }

    static of(iterable) {
        return new Stream( iterable[Symbol.iterator]() )
    }

    filter(f) {
        return new Stream(ffilter(this.iter, f))
    }

    toList() {
        return [...this.iter]
    }

    limit(max) {
        return new Stream(flimit(this.iter, max))
    }

    static iterate(initial, delta) {
        return new Stream(fiterate(initial, delta))
    }

    findFirst(f) {
        return new Stream(ffindFirst(this.iter, f))
    }
}

// console.log("--> ", Stream.of([1,2,3,4,5,6])
//             .filter(x => x % 2 == 0)
//             .toList()
//             )

// console.log("--> ", Stream.of([1,2,3,4,5,6])
//         .limit(3)
//         .toList()
// )

// console.log("--> ", Stream.iterate(0, s => s + 1)
//         .limit(100)
//         .toList()
// )

// console.log("--> ", Stream.iterate(50, s => s + 2)
//         .limit(100)
//         .findFirst(n => n % 6 == 0)
//         .toList()
// )