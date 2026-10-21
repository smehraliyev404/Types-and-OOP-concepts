using System;

class Animal {
    // subclasses can override it, run time
    public virtual void Speak() {
        Console.WriteLine("Animal.Speak");
    }

    // compile time
    public void Info() {
        Console.WriteLine("Animal.Info");
    }
}

class Dog : Animal {
    // replaces Animal.Speak
    public override void Speak() {
        Console.WriteLine("Dog.Speak");
    }

    // hides Animal.Info, but only for Dog variables
    public new void Info() {
        Console.WriteLine("Dog.Info");
    }
}

class Puppy : Dog {
    // new on a virtual method, Dog.Speak is not overridden
    public new void Speak() {
        Console.WriteLine("Puppy.Speak");
    }

    public void ParentSpeak() {
        base.Speak();
    }
}

class Program
{
    static void Main()
    {
        Animal a = new Animal();
        Dog d = new Dog();
        Animal ad = new Dog();
        Puppy p = new Puppy();
        Animal ap = new Puppy();

        Console.WriteLine("virtual + override (dynamic binding)");
        Console.Write("a.Speak(): ");
        a.Speak();
        Console.Write("d.Speak(): ");
        d.Speak();
        Console.Write("ad.Speak(): ");
        ad.Speak();

        Console.WriteLine();
        Console.WriteLine("new on a normal method (static binding)");
        Console.Write("a.Info(): ");
        a.Info();
        Console.Write("d.Info(): ");
        d.Info();
        Console.Write("ad.Info(): ");
        ad.Info();

        Console.WriteLine();
        Console.WriteLine("new on a virtual method");
        Console.Write("p.Speak(): ");
        p.Speak();
        Console.Write("ap.Speak(): ");
        ap.Speak();
        Console.Write("p.ParentSpeak(): ");
        p.ParentSpeak();
    }
}
