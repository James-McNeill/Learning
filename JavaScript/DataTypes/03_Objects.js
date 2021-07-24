// Objects
// Collections of name-value pairs

var myName = {1: "James"};
console.log(myName);

// One method to create object
var myObject = new Object();
myObject['1'] = "James";
myObject['2'] = "Sally";
myObject['3'] = "Bob";
console.log(myObject);

// Object literal syntax, preffered
var myOtherObject = {
  1: "James"
  ,2: "Sally"
  ,3: "Bob"
  ,4: "Billy"
  ,5: "Jane"
}; 

myOtherObject['6'] = "Aisling";

// Dictionary entry - remember to keep keys unique
var anotherObject = {
  firstName: "James"
  ,lastName: "McNeill"
  ,age: 31
  ,numbers: {
    mobile: "000123"
    ,home: "555555"
  }
  ,address: "123 Fake Street"  
};
// Added a nested object (numbers)

var userMobileNumber = anotherObject.numbers.mobile;

console.log(anotherObject);
console.log(anotherObject.firstName);
console.log(anotherObject['firstName']);
console.log(anotherObject.numbers);
console.log(anotherObject.numbers.mobile);
console.log(anotherObject.numbers.home);

console.log(userMobileNumber);

var donut = {
  type: "coconut"
  ,glazed: true
  ,sweetness: 8
  ,hasChocolate: false
  ,sayHi: function(){
    console.log("Hi");
  }
  ,sayType: function() {
    console.log("Type: " + this.type);
  }
  ,showSweetness: function() {
    console.log("Sweetness: " + this.sweetness + "/10");
  }
};

// console.log(donut)

// Can also plug a function into an object

// Create simple function

function sayHi() {
  console.log("Say Hi!")
};

sayHi();

// Using the functions from an object
donut.sayHi();
donut.sayType();
donut.showSweetness();

// Constructor pattern for creating objects - boilerplat code
function Donut(type, glazed, sweetness, hasChocolate) {
  this.type = type;
  this.glazed = glazed;
  this.sweetness = sweetness;
  this.hasChocolate = hasChocolate;
  this.sayType = function() {
    console.log("Type: " + this.type);
  };
  this.showSweetness = function() {
    console.log("Sweetness: " + this.sweetness + "/10");
  };
};

// Instantiating the function
var coconutDonut = new Donut("coconut", false, 8, true);
// console.log(coconutDonut);
var vanillaDonut = new Donut("vanilla", true, 10, false);
vanillaDonut.showSweetness();
