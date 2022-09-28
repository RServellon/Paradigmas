package com.una.pp;

public class Source{
	
	public static int factorialWhile(int n){
		int contador = 1;
		while(n > 0){
			contador *= n;
			n--;
		}
		return contador;
	}
	public static void main(String... args){
		System.out.println("*** Practica 1 22 Agosto ***");
		System.out.println(factorialWhile(Integer.valueOf(args[0])));
	}
}