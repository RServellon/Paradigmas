// 2) Dada una lista a de Double, verificar con datos experimentales las hipótesis (en Java) sobre el algoritmo: a.stream().reduce((a, x) -> a + Math.exp(Math.log(x+1)))

long startTime = System.nanoTime();
Random rd = new Random(); 
double randomValue = rd.nextDouble(0, 100);

//Boxed: operacion intermedia, lazy,devuelve un Stream que consta de los elementos de este flujo, cada uno encapsulado en un double.
List<Double> a = DoubleStream.iterate(randomValue, n -> randomValue).limit(100000).boxed().collect(Collectors.toList());

// 2) Dada una lista a de Double, verificar con datos experimentales las hipótesis (en Java) sobre el algoritmo: a.stream().reduce((a, x) -> a + Math.exp(Math.log(x+1))) 
// a) Si a.size() es pequeño usar parallel resultará en promedio en un tiempo de corrida peor que sin usarlo (el paralelismo deteriora el tiempo de corrida).
// b) Si  a.size() es apropiadamente grande (según sus posibilidades de máquina en cores y memoria) el usar parallel mejora sustancialmente el tiempo de corrida.
a.stream().reduce((a, x) -> a + Math.exp(Math.log(x+1))).get()
// a.stream().parallel().reduce((a, x) -> a + Math.exp(Math.log(x + 1))).get()

long endTime = System.nanoTime();
long timeElapsed = endTime - startTime;

println("Execution time in milliseconds: " + timeElapsed / 1000000);
// System.out.println("Execution time parallel in milliseconds: " + timeElapsed / 1000000);


