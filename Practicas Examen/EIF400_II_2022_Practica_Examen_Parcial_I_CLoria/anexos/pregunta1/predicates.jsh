<T> Predicate<T> implies(Predicate<T> p, Predicate<T> q){
        // TO DO
        return null;
}


System.out.format("Version A: implies(x -> x > 0, x -> x >= 0).test(10) : %b%n", 
                           implies((Integer x ) -> x > 0, (Integer x) -> x >= 0).test(10));
                           
                           
