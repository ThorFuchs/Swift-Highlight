from dataclasses import dataclass

@dataclass
class Greeting:
    name: str

    def message(self) -> str:
        return f"Hello, {self.name}! ✨"

print(Greeting("Python").message())
