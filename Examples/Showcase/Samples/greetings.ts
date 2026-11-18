type Greeting = { name: string; emoji?: string };

function greet({ name, emoji = "✨" }: Greeting) {
  return `Hello, ${name}! ${emoji}`;
}

const languages = ["Swift", "TypeScript"];
for (const name of languages) {
  console.log(greet({ name }));
}
