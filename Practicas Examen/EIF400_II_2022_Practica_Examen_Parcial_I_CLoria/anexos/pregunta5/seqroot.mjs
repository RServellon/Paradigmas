export function* seqRoot(a){
    //TO DO
    k = 0
    obj = {n: 0, x: a/2}
    while(true){
        yield obj
        k++
        obj = { n:k, x: (obj.x + a/obj.x)/2 }
    }

}


export function first(gen, test){
    // TO DO
    valor = seqRoot(gen)
    while(true){
        if(test(valor.next().value.x)){
            break;
        }
    }
    return valor.next()
}

export function root(a, {max=20, epsilon=1e-10}){
    // TO DO
    return {n:0, x:0}
}

