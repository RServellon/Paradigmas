
class IterTools{
    
    public static <T> Iterator<T> iterate(T seed, UnaryOperator<T> f){
        // TODO
        return null;
    }        
}
var seed = 10;
UnaryOperator<Integer> f = x -> x + 1;
var iter = IterTools.iterate(seed, f);
Arrays.asList(10, 11, 12).forEach( i -> 
    println(String.format("Itertools Version A: (seed=%d f = x -> x + 1 ) next.value(%d) = %d", seed, i, iter.next()))   
);