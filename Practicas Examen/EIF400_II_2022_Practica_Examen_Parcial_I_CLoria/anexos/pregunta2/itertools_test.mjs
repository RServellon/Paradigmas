import {IterTools} from './itertools.mjs'

console.log('*** Itertools ****')
const seed = 10
const f = x => x + 1
const gen = IterTools.iterate(seed, f)
for ( const i of [0, 1, 2] )
    console.log(`Version A: Itertools (seed=${seed} f = x => x + 1): next.value(${seed + i}) = ${gen.next().value} `)