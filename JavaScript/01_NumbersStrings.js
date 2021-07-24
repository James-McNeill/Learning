// Types

// Number
console.log(10);
console.log(typeof 10);
console.log(typeof "10");
console.log(10 + 1);
console.log(10 * 2);
// Can bring in the built in packages
console.log(Math.random());
console.log(Math.PI);
// Trying to add a string to number results in concatenation
console.log("10" + 213);
// Correcting to a integer
console.log(parseInt("10") + 213);
console.log(+"10"); // convert string to a number
console.log(parseInt("10", 10)); // Adding a base to it as an optional argument
console.log(parseInt("Hello")); // NaN returned as not a number
console.log(isNaN("hello")); // Check is Not a Number

// Strings
// Sequence of Unicode characters
console.log("Hello");
