class Greeting
  def initialize(name)
    @name = name
  end

  def message
    "Hello, #{@name}! ✨"
  end
end

puts Greeting.new("Ruby").message
