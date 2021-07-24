// Variables

// List variables
// Note: variables are case sensitive
var myName = "James";
// myName = "Jane"; // It is possible to re-assign but need to be careful and avoid this
var myLastName = "Smith";
var myFavNum = 24;
var myArray = [1, 2, 3, 4, 5, "Bob"]; // arrays can hold different data types
var myObject = {
  name: "James",
  age: 32
}; // objects can hold different data types

console.log(typeof myName);
console.log(myName);
console.log(myFavNum);
console.log(myArray);
console.log(typeof myObject);
console.log(myObject);

// Write a function to print to the console
function sayHi() {
  console.log("Hi" + " " + myName)
}

sayHi()

// Creating a counter to increment
var count = 1;

function increase() {
  count += 1;
  console.log(count)
}

increase()
increase()
increase()

// Boolean data type
var amJames = true;

console.log(amJames);

// Null data type
var amINull = null;

console.log(amINull);

// Variables with different scope
// Make sure to avoid re-assigning a variable to the same variable name
function sayName() {
  var myName = "Chris"; // variable is defined locally
  console.log(myName)
}

console.log(myName); // variable defined globally
sayName();

// Make sure to avoid declaring reserved words as variable names

// Also can't make use of numbers to start the variable name. Can make use of the underscore. A dollar sign can be used to start a variable name
