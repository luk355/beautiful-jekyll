---
layout: post
title: Fluent Builder patterns - compared
tags: [Builder pattern, C#, design patterns]
---


```csharp
public class Person {
    public string Firstname {get;set;}
    public string Surname {get;set;}
}

// usage
Person person = new PersonBuilder()
    .WithFirstname("Jack")
    .WithSurname("Sparrow")
    .Build();
```

## TODO

```csharp
public class PersonBuilder {
    private string firstname;
    private string surname;

    public PersonBuilder WithFirstname(string firstname){
        this.firstname = firstname;
        return this;
    }

    public PersonBuilder WithSurname(string surname) {
        this.surname = surname;
        return this;
    }

    public Person Build() {
        return new Person() {
            Firstname = this.firstname,
            Surname = this.surname
        };
    }
}
```

**Pros:**

**Cons:**


## Immutable builder

```csharp
public class ImmutablePersonBuilder {
    private string firstname;
    private string surname;

    ImmutablePersonBuilder(){
    }

    private ImmutablePersonBuilder(string firstname, string surname){
        this.firstname = firstname;
        this.surname = surname;
    }

    public ImmutablePersonBuilder WithFirstname(string firstname){
        return new ImmutablePersonBuilder(firstname, this.surname);
    }

    public ImmutablePersonBuilder WithSurname(string surname){
        return new ImmutablePersonBuilder(this.firstname, surname);
    }

    public Person Build(){
        return new Person() {
            Firstname = this.firstname,
            Surname = this.surname
        };
    }
}
```

**Pros:**

**Cons:**


## Functional builder

Following [Builder: C#][1] article.

```csharp
static class FnUtils
{
    public static Func<A,C> Compose<A,B,C>(Func<A,B> f1, Func<B, C> f2) 
    {
        return (a) => f2(f1(a));
    }
}
```

**Pros:**

**Cons:**


## Libraries available in NuGet


## Resources

* [Builder: C# (Ted Neward)][1]
* [The builder pattern in practice (Jose Luis Ordiales)][2]
* [Think functional: Advanced builder pattern using lambda (Sujit Kamthe)][3]

[1]: http://blogs.tedneward.com/patterns/Builder-CSharp/
[2]: https://jlordiales.me/2012/12/13/the-builder-pattern-in-practice/
[3]: https://medium.com/beingprofessional/think-functional-advanced-builder-pattern-using-lambda-284714b85ed5
