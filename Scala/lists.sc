// Lists
// The immutable collections object within Scala

// Initialize a list with an element for each round's prize
val prizes = List(10, 15, 20, 25, 30)
println(prizes)

// Prepend to prizes to add another round and prize - the operator cons (::) is used to prepend
val newPrizes = 5 :: prizes
println(newPrizes)
