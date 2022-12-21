package com.una.pp.quizone;

class Source{

    public static int fibonacciRec(int n){
        return n == 0 || n == 1 ? 1 : 2 * fibonacciRec(n - 1) + 3 * fibonacciRec(n - 2);
    }

    public static int fibonacciIter(int n){
        int fibo0 = 1;
        int fibo1 = 1;
        int tempo = 0;
        for(int i = 1; i < n; i++){
            tempo = fibo1;
            fibo1 = fibo1 * 2 + fibo0 * 3;
            fibo0 = tempo;
        }
        return fibo1;
    }
    
    public static void main(String... args){
    
        try{
            int num = Integer.parseInt(args[0]);
            if(num >= 10 || num < 0){
                throw new Exception("el numero debe estar entre 0 - 9");
            }
            System.out.println(num);
            System.out.println(fibonacciRec(num));
            
        }
        catch(Exception e){
            System.out.println(e);
        }
    }

}