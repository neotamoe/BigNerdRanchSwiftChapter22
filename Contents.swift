//: Playground - noun: a place where people can play

import UIKit

// GENERICS
// generics allow you to write types and functions that use types that are not yet known to you or the compiler.

// Iterator Protocol is a built-in
// protocol IteratorProtocol {
//    associatedtype
//    mutating func next() -> Element?
//}

//creating StackIterator
struct StackIterator<T>: IteratorProtocol {
    
    var stack: Stack<T>
    
    mutating func next() -> T? {
        return stack.pop()
    }
}




// Sequence - is an associated type protocol
// protocol Sequence {
//    associatedtype Iterator: IteratorProtocol
//    func makeIterator() -> Iterator
//}


// make a generic stack (first in, last out)
// <Element> is a placeholder type for declaring a generic.  The type declared in the <> can be used anywhere a concrete type could be used
// then you also have to declare what kind of element you're using when you call an instance (var intStack = Stack<Int>()
struct Stack<Element>: Sequence {
    var items = [Element]()
    
    mutating func push(_ newItem: Element) {
        items.append(newItem)
    }
    
    mutating func pop() -> Element? {
        guard !items.isEmpty else {
            return nil
        }
        
        return items.removeLast()
    }
    
    // mapping on a stack
    func map<U>(_ f: (Element) -> U) -> Stack<U> {
        var mappedItems = [U]()
        for item in items {
            mappedItems.append(f(item))
        }
        return Stack<U>(items: mappedItems)
    }
    
    // make Stack conform to Sequence
    func makeIterator() -> StackIterator<Element> {
        return StackIterator(stack: self)
    }
    
    // pushing items from an array onto a stack
//    mutating func pushAll(_ array: [Element]) {
    mutating func pushAll<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        for item in sequence {
            self.push(item)
        }
    }
}



var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)
var doubledStack = intStack.map {2 * $0}

print(intStack.pop())
print(intStack.pop())
print(intStack.pop())

print(doubledStack.pop())
print(doubledStack.pop())

var stringStack = Stack<String>()
stringStack.push("this is a string")
stringStack.push("another string")
print(stringStack)
print(stringStack.pop())
// intStack and stringStack are both Stack instances, but they do not have the same type


// can create your own map(_:) method (defined on Array in Chapter 13
// below says: myMap is function name
// <T,U> are the two placeholder types
// [T] input array--each item has type T
// _ f: (T) -> (U) -- closure that takes an argument of type T and returns a value of type U
// [U] return value is an array where each item has type U
func myMap<T, U> (_ items: [T], _ f: (T) -> (U)) -> [U] {
    var result = [U]()
    for item in items {
        result.append(f(item))
    }
    return result
}

let strings = ["one", "two", "three"]
let stringLengths = myMap(strings) {$0.characters.count}
print(stringLengths)

// TYPE CONSTRAINTS
// type constraints place restrictions on the concrete types that can be passed to generic functions.
//two kinds of constraints: 1) constraint that a type be a subclass of a given class and 2) that a type conform to a protocol (a protocol composition)

func checkIfEqual<T: Equatable>(_ first: T, _ second: T) -> Bool {
    return first == second
}

print(checkIfEqual(1,1))
print(checkIfEqual("a string", "a string"))
print(checkIfEqual("a string", "a different string"))

func checkIfDescriptionsMatch<T: CustomStringConvertible, U: CustomStringConvertible>(_ first: T, _ second: U) -> Bool {
    return first.description == second.description
}

print(checkIfDescriptionsMatch(Int(1), Int(1)))
print(checkIfDescriptionsMatch(1, 1.0))
print(checkIfDescriptionsMatch(Float(1.0), Double(1.0)))


var myStack = Stack<Int>()
myStack.push(10)
myStack.push(20)
myStack.push(30)

var myStackIterator = StackIterator(stack: myStack)
while let value = myStackIterator.next() {
    print("got \(value)")
}

for value in myStack {
    print("for-in loop: got \(value)")
}

myStack.pushAll([1, 2, 3])
for value in myStack {
    print("after pushing: got \(value)")
}

var myOtherStack = Stack<Int>()
myOtherStack.pushAll([1, 2, 3])
myStack.pushAll(myOtherStack)
for value in myStack {
    print("after pushing items onto stack, got \(value)")
}


// protocols cannot be made generic (functions, types and methods can be)
// protocols support a similar and related feature: associated types




