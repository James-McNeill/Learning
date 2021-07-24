// Booleans

// assigning variable
var shouldBeTrue = true;
console.log(shouldBeTrue === true); // check if the statement matches
console.log(shouldBeTrue === false);
var shouldBeNull = null; // an empty variable assigns to false

console.log(shouldBeNull);

// if statement
if (shouldBeTrue === true) {
  console.log("Hello!");
}
else {
  console.log("This var is not true");
}

// Shows as true
var hasContent = "segegseg"; 
var myArray = ["1","2","3","4"];
var myArray1 = [];
var myArray2 = ["gaewgg", 1, 2, 3, "dad"];

// Shows as false
var doesNotHaveContent = ""; 
var isZero = 0;
var nonAssignedVariable; // evaluates to undefined
var isFalse = false;
var isNotANumber = NaN;
var myArray3; // undefined, evaluates to false

console.log(hasContent === true);

console.log(Boolean(hasContent));
console.log(Boolean(doesNotHaveContent));
console.log(Boolean(isZero));
console.log(Boolean(nonAssignedVariable));
console.log(Boolean(isNotANumber));
console.log(Boolean(myArray));

if (myArray3) {
  console.log("Has truthy values");
}
else {
  console.log("Has falsey values");
}

console.log(null === undefined); // not the same
