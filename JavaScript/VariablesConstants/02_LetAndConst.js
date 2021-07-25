// Creating simple function
function sayHi() {
  var shouldSayHi = true;
  if (shouldSayHi === true) {
    var myName = "James";
    console.log("Hi"+ " "+ myName)
  }
}

sayHi();

// Unintended consequences of scope in the function
function sayHiNew() {
  var shouldSayHi = true;
  var reallySayHi = true;

  if (shouldSayHi === true) {
    var myName = "James";

    if (reallySayHi === true) {
      var myLastName = "Smith";
    }
  }
  // Can still access this variable and change it
  myLastName = "Jones";
  console.log("Hi" + myName + myLastName)
}

sayHiNew();

// This should fail as it is outside the scope of the function
// console.log(myName);

// Making use of let to set variable
function sayHiNew1() {
  // Adding the let here allows the values to be used throughout the function
  let shouldSayHi = false;
  let myName; // Declare. Allow for creating value later

  if (shouldSayHi === true) {
    let myName1 = "James";
    myName = "James1";
    console.log("Hi " + myName);
  }
  else {
    myName = "Bob";
    console.log("Hi " + myName);
  }
  // Trying to access the variable outside the if block will not work
  // console.log("Hi " + myName1);
}

sayHiNew1();

// // Const - constant
// function sayHiNew2() {
//   let shouldSayHi = false;
//   const myName = "James"; // Have to declare a value. However this can not be reset later in the function

//   if (shouldSayHi === true) {
//     myName = "James1";
//     console.log("Hi " + myName);
//   }
//   else {
//     myName = "Bob";
//     console.log("Hi " + myName);
//   }
// }

// sayHiNew2();

// Const example - however the data is not immutable
// const myNewName = "Jack";
// myNewName = "John"; // Can't reassign
// console.log(myNewName);

// Const array
const myArray = [1, 2, 3];
// myArray = [4, 5, 6]; // Can't use this method to overwrite data
console.log(myArray);
// However we can push data into the array
myArray.push(4);
console.log(myArray);

// Const myObject
const myObject = {name: "James"};
console.log(myObject);
myObject.name = "Jack";
console.log(myObject);

// Understand const in scope of function
function sayHello() {
  // If we declare const within this scope then the const can print
  const myName = "Jane";
  if (true) {
    const myName = "Adam";
  }
  console.log(myName); 
}

sayHello();

// In general use const
// For an undefined value use let
// Benefit for using both of these methods over var is due to block scoping
