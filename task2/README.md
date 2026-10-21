# Task 2 | Technical Documentation

## Overview

A C# program that shows the difference between dynamic and static binding, using the `virtual`, `override` and `new` keywords.

There are three classes, each one inheriting from the previous one:

- `Animal` has `Speak()`, which is `virtual`, and `Info()`, which is a normal method.
- `Dog : Animal` overrides `Speak()` with `override` and hides `Info()` with `new`.
- `Puppy : Dog` hides `Speak()` with `new`, and calls the parent version with `base.Speak()`.

## Structure

```
task2/
├── code/
│   └── Binding.cs // the three classes and Program.Main()
└── README.md
```

The output is split into 3 parts:

1. `virtual` + `override`: dynamic binding
2. `new` on a normal method: static binding
3. `new` on a `virtual` method, and `base.Speak()`

## Requirements

- Either an online compiler, or the .NET SDK. I used .NET 6.

## How to run

Online: open https://www.onlinegdb.com, choose C# as the language, paste the contents of `code/Binding.cs` and press Run.

From the `task2` folder:

```bash
dotnet new console -o demo
```

```bash
cp code/Binding.cs demo/Program.cs
```

```bash
dotnet run --project demo
```

`dotnet new console` makes a small project with its own `Program.cs`, and the second command replaces it with our file.

## Sample output

```
virtual + override (dynamic binding)
a.Speak(): Animal.Speak
d.Speak(): Dog.Speak
ad.Speak(): Dog.Speak

new on a normal method (static binding)
a.Info(): Animal.Info
d.Info(): Dog.Info
ad.Info(): Animal.Info

new on a virtual method
p.Speak(): Puppy.Speak
ap.Speak(): Dog.Speak
p.ParentSpeak(): Dog.Speak
```

## Discussion

The interesting variable is `ad`: its declared type is `Animal`, but the object inside is a `Dog`. We can call this a polymorphic variable.

In the first part, `ad.Speak()` prints `Dog.Speak`. Because `Speak()` is `virtual` in `Animal` and `override` in `Dog`, the method is chosen at run time from the real object, not from the variable type. This is dynamic binding.

In the second part, `ad.Info()` prints `Animal.Info`, even though it is the same `Dog` object. `Info()` is not virtual, so the compiler picks the method from the declared type `Animal` already at compile time. `Dog.Info()` with `new` only hides the parent method, so it runs only when the variable itself is a `Dog` (`d.Info()`). This is static binding.

The third part shows that `new` can also be put on a virtual method, and then it breaks the chain. `p.Speak()` gives `Puppy.Speak`, but `ap.Speak()` gives `Dog.Speak`. The run time looks for the last `override` of `Animal.Speak` and finds it in `Dog`, because `Puppy.Speak` is a new, separate method. `base.Speak()` calls the parent version.

I also wanted to know what `new` really does, so I removed it from both methods and compiled again. The output was exactly the same. The compiler only gave two warnings:

```
warning CS0108: 'Dog.Info()' hides inherited member 'Animal.Info()'. Use the new keyword if hiding was intended.
warning CS0114: 'Puppy.Speak()' hides inherited member 'Dog.Speak()'. To make the current member override that implementation, add the override keyword. Otherwise add the new keyword.
```

So `new` does not change the binding. It just tells the compiler that hiding the method was done on purpose.

I think the C# design is a good one. Like C++, it makes static binding the default, and you have to write `virtual` to get dynamic binding. Java does the opposite: every method is dynamically bound unless it is `final`, `static` or `private`. Static binding is faster, but the bigger advantage is that the base class decides which methods can be changed. C# also makes the subclass write `override`, so you cannot override a method by accident just by using the same name. The downside is that hiding with `new` can be confusing: the same object answers differently depending on the variable type, as `ad.Info()` and `d.Info()` show. That is why I would use `new` only when I really have to.