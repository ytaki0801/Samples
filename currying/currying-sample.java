// import java.util.function.Function;
// 
// public class curry {
//   public static void main(String[] args) {
//     Function<Integer, Function<Integer, Boolean>> f = x -> y -> x > y;
//     System.out.println(f.apply(10).apply(20));
//   }
// }

Function<Integer, Function<Integer, Boolean>> f = x -> y -> x > y
System.out.println(f.apply(10).apply(20))
