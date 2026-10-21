# Task 3 | Technical Documentation

## Overview

A small library catalog in Ruby. It manages three types of items (books, DVDs and CDs) and shows the OOP principles: class design, inheritance, encapsulation and polymorphism.

- `LibraryItem` is the base class. It has the common properties `title`, `author` and `publication_year`, a `display_info` method that prints the title and year, and `item_type`, which returns the name of the type.
- `Book`, `DVD` and `CD` inherit from `LibraryItem` (`class Book < LibraryItem`). Each one adds a `genre`, overrides `display_info` (calls `super` first, then prints the author with its own label and the genre) and overrides `item_type`.
- `DVD` also has `director` and `CD` has `artist`. They return the value stored in `author`, because the test code from the assignment passes the director/artist in the author position and a genre as the 4th argument.
- `Library` keeps a collection of items and has `add_item`, `remove_item`, `display_item` and `display_all_items`.

## Structure

```
task3/
├── code/
│   └── library.rb // the classes, the test code from the assignment and one extra test
└── README.md
```

The file has two parts:

1. The five classes.
2. The test code from the assignment, followed by one extra test: removing an item and displaying the library again. The given test code never calls `remove_item`, so this shows that it works.

## Requirements

- Ruby (it comes with macOS). I used the system one, Ruby 2.6.10.

## How to run

From the `task3` folder:

```bash
ruby code/library.rb
```

## Sample output

```
[Book]
Title: Concepts of Programming Languages
Year: 2015
Author: Robert Sebesta
Genre: Programming

[DVD]
Title: Inception
Year: 2010
Director: Christopher Nolan
Genre: Science Fiction

[CD]
Title: A Day at the Races
Year: 1976
Artist: Queen
Genre: Rock
Added: Concepts of Programming Languages
Added: Inception
Added: A Day at the Races
Library has 3 item(s):

[Book]
Title: Concepts of Programming Languages
Year: 2015
Author: Robert Sebesta
Genre: Programming

[DVD]
Title: Inception
Year: 2010
Director: Christopher Nolan
Genre: Science Fiction

[CD]
Title: A Day at the Races
Year: 1976
Artist: Queen
Genre: Rock
Removed: Inception
Library has 2 item(s):

[Book]
Title: Concepts of Programming Languages
Year: 2015
Author: Robert Sebesta
Genre: Programming

[CD]
Title: A Day at the Races
Year: 1976
Artist: Queen
Genre: Rock
```

## Discussion

Inheritance: the common properties and the common part of `display_info` are written only once, in `LibraryItem`. Each subclass calls `super` in `initialize` and in `display_info`, and adds only what is different. Subclasses are defined with `<`.

Encapsulation: in Ruby all instance variables are private, and other objects cannot access them directly. I only added readers with `attr_reader` and no writers, so after an item is created its title or year cannot be replaced from outside (`book.title = "x"` gives a `NoMethodError`). The reader still returns the string object itself, so something like `book.title << "x"` would change it. To prevent that too, the strings could be frozen with `freeze`. In `Library`, `@items` has no reader at all, so the collection can only be changed through `add_item` and `remove_item`. `add_item` also checks the type and refuses anything that is not a `LibraryItem`.

Polymorphism: `display_item(item)` just calls `item.display_info`, and `display_all_items` calls it for every item. The `Library` class never checks whether an item is a book, a DVD or a CD, but each one still prints its own details. The method that runs is chosen at run time from the real object. This is dynamic binding. `item_type` works the same way: `LibraryItem#display_info` calls `item_type`, and the subclass version runs.

What I noticed is that in Ruby this works even without inheritance. Ruby is dynamically typed, so like in Smalltalk every method call is bound at run time by looking up the method in the object's class, then its superclass and so on. So `display_item` would work for any object that has a `display_info` method, even one that does not inherit from `LibraryItem`. In this program the base class is still useful, because it keeps the shared code in one place, and the `is_a?` check in `add_item` uses it to decide what belongs in the library.