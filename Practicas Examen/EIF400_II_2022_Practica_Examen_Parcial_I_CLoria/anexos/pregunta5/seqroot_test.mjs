import {root} from './seqroot.mjs'

// Testing

const [max, epsilon] = [20, 1e-10]
console.log(`*** Ejemplo Pregunta 5 Version A max=${max} epsilon=${epsilon} ***`)
for( let a of [4, 9, 16, 25]){
   let {n, x} = root(a, {max, epsilon})
   console.log(`Version A: root(${a})= ${x} (last n = ${n})`)
}
console.log()
