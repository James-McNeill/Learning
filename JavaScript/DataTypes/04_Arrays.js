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
console.log(coconutDonut);
var vanillaDonut = new Donut("vanilla", true, 10, false);
vanillaDonut.showSweetness();
// Additional parameter added which is not present in vanillaDonut
coconutDonut.tasteGood = true;
console.log(coconutDonut);
console.log(vanillaDonut);

// Arrays
Collection of data
var myArray = [1, 2, 3, "checking", "out", true];
console.log(myArray.length);
console.log(myArray[5]);

var myNamesArray = new Array();
var myNamesArray = []; // array literale notation
myNamesArray[0] = "James";
myNamesArray[1] = "Test";
myNamesArray[10] = "Test1"; // can add value to end with undefined entries

var myNamesArray = ["James", "Jane", "Jessica", "John", ["blue",
                                                        "orange",
                                                        "yellow",
                                                        "red"]];
myNamesArray.push(10); // adds an element
var lastName = myNamesArray.pop(); // remove element
console.log(myNamesArray[4][0]); // extract element from internal array

console.log(myNamesArray);
console.log(myNamesArray.length); // length of zero index array
console.log(myNamesArray[10]); // returns "undefined"

var myNamesArray = ["Zack","James", "Jane", "Jessica", "John"]
var sortedArray = myNamesArray.sort();
// sortedArray.reverse();
console.log(sortedArray);

// Concat
var myOtherNames = ["Jake","Amy","Timmy"];
var myOtherNames2 = ["Pete", "George"];
var concattedArray = myNamesArray.concat(myOtherNames,
                                        myOtherNames2);
console.log(concattedArray);

// Slice
var slicedArray = concattedArray.slice(5);
var slicedArray1 = concattedArray.slice(5, 9);
console.log(slicedArray);
console.log(slicedArray1);

// Convert to string
var joinedArray = myNamesArray.join(", ");
// console.log(joinedArray);

// Array can contain objects
var myDonuts = [coconutDonut, vanillaDonut];
// console.log(myDonuts);
var lastDonut = myDonuts[1];
lastDonut.sayType();
lastDonut.showSweetness();
