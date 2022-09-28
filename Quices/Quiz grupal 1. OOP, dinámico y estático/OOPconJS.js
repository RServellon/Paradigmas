class Animal {
    constructor (name) {
        this.name = name;
    }

    makeSound() {
        return 'Sonido animal';
    }
}

class Dog extends Animal {
    constructor (name) {
        super(name);
    }

    makeSound() {
        return 'Woof';
    }
}

class Cat extends Animal {
    constructor (name) {
        super(name);
    }

    makeSound() {
        return 'Mawh';
    }
}

const animal1 = new Dog('Pulgas');
const animal2 = new Cat('Chispas');

console.log(animal1.makeSound());
console.log(animal2.makeSound());

console.log(typeof Cat);