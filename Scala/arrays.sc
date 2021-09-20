// Creating a new array. The array should be instansiated as an immutable object type. The array object is mutable by nature
// Below highlights the different options when using Arrays in scala. Unfortunately, due to their mutable nature they are
// not actively used in the wild as the mutability encourages side effects

// Create and parameterize an array for a round of Twenty-One
val hands: Array[Int] = new Array[Int](3)

// Initialize the first player's hand in the array
hands(0) = tenClubs + fourDiamonds

// Initialize the second player's hand in the array
hands(1) = nineSpades + nineHearts

// Initialize the third player's hand in the array
hands(2) = twoClubs + threeSpades

// Alternative option was to create and populate the array in one step. The challenge with this option
// is that the array is not created explicitly. Therefore the data types that are input could get misinterpreted.
// It is always safer to outline the data type of the Array at the beginning. Or else an Array[Any], will be created
// which can be populated with multiple data type's in the same Array object.
// Create, parameterize, and initialize an array for a round of Twenty-One
val hands = Array(tenClubs + fourDiamonds,
              nineSpades + nineHearts,
              twoClubs + threeSpades)

// Update Arrays
// Initialize player's hand and print out hands before each player hits
hands(0) = tenClubs + fourDiamonds
hands(1) = nineSpades + nineHearts
hands(2) = twoClubs + threeSpades
// Foreach method allows for multiple print statements for each Array element
hands.foreach(println)

// Add 5♣ to the first player's hand
hands(0) = hands(0) + fiveClubs

// Add Q♠ to the second player's hand
hands(1) = hands(1) + queenSpades

// Add K♣ to the third player's hand
hands(2) = hands(2) + kingClubs

// Print out hands after each player hits
hands.foreach(println)
