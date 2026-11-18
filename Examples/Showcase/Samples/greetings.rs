struct Greeting<'a> {
    name: &'a str,
}

impl Greeting<'_> {
    fn message(&self) -> String {
        format!("Hello, {}! ✨", self.name)
    }
}

fn main() {
    let greeting = Greeting { name: "Rust" };
    println!("{}", greeting.message());
}
