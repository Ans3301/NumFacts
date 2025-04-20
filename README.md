# NumFacts
NumFacts is a lightweight Swift Package that provides an easy interface for fetching facts about numbers using the [Numbers API](http://numbersapi.com/).

## 🧰 Requirements

- iOS 13.0+
- macOS 12.0+
- Swift 5.7+
- Xcode 13.0+

## 📦 Installation

**Swift Package Manager**

File > Add Package Dependency  
Enter the URL: https://github.com/Ans3301/NumFacts  
Select the version and add it to your project.

## 🚀 Usage

```swift
import NumFacts

let numFacts = NumFacts()

// Fetch a fact for a specific number
do {
  let fact = try await numFacts.factAboutNumber(number: 42)
} catch {}

// Fetch a fact for a random number
do {
  let fact = try await numFacts.factAboutRandomNumber()
} catch {}

// Fetch a fact for a random number in a range
do {
  let fact = try await numFacts.factAboutRandomNumberInRange(min: 7, max: 29)
} catch {}

// Fetch facts for multiple numbers
do {
  let facts = try await numFacts.factsAboutMultipleNumbers(numbers: [1, 12, 45])
} catch {}

