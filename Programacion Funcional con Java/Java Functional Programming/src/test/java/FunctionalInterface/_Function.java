package FunctionalInterface;

import java.util.function.Function;

public class _Function {
    public static void main(String[] args) {
        int increment = increment(0);
        System.out.println(increment);

        Integer increment2 = incrementByOneFunction.apply(1);
        System.out.println(increment2);

        int multiple = multipleBy10Function.apply(increment2);
        System.out.println(multiple);

        Function<Integer, Integer> addByOneAndThenMultiplyByTen = incrementByOneFunction.andThen(multipleBy10Function);
        System.out.println(addByOneAndThenMultiplyByTen.apply(4));
    }

    static Function<Integer, Integer> incrementByOneFunction = number -> number + 1;
    static Function<Integer, Integer> multipleBy10Function = number -> number * 10;

    static int increment(int number) {
        return number + 1;
    }
}
