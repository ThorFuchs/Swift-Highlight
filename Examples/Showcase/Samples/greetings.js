const greetings = ["hello", "hallo", "hola"];

export function greet(name, language = 0) {
  const word = greetings[language] ?? greetings[0];
  return `${word}, ${name}! ✨`;
}

console.log(greet("JavaScript", 1));
