class Integer
  def prime?
    return false if self == 1

    upper_limit = self ** 0.5
    range_array = *(2..upper_limit)
    range_array.all? { |x| self % x != 0 }
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    return @sequence = [] if limit == 0

    numerator = 1
    denominator = 1
    sequence = [Rational(numerator, denominator)]

    while sequence.length < limit do
      element = get_next_rational(numerator, denominator)
      numerator, denominator = element[0], element[1]
      rational_number = Rational(numerator, denominator)
      sequence << rational_number unless sequence.include? rational_number
    end
    @sequence = sequence
  end

  def each(&block)
    @sequence.each(&block)
  end

  def -(array)
    @sequence - array
  end

  private
  def get_next_rational(numerator, denominator)
    if numerator.odd? and denominator == 1
      numerator += 1
    elsif numerator == 1 and denominator.even?
      denominator += 1
    elsif (numerator + denominator).even?
      numerator += 1
      denominator -= 1
    elsif (numerator + denominator).odd?
      numerator -= 1
      denominator += 1
    end
    [numerator, denominator]
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    return @sequence = [] if limit == 0

    number = 2
    sequence = [number]
    while sequence.length < limit  do
      number += 1
      sequence.push(number) if number.prime?
    end
    @sequence = sequence
  end

  def each(&block)
    @sequence.each(&block)
  end

  def -(array)
    @sequence - array
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    return @sequence = [] if limit == 0
    return @sequence = [first] if limit == 1

    current = second
    previous = first
    sequence = [previous, current]
    while sequence.length < limit
      current, previous = current + previous, current
      sequence.push(current)
    end
    @sequence = sequence
  end

  def each(&block)
    @sequence.each(&block)
  end

  def [](index)
    @sequence[index]
  end
end

module DrunkenMathematician
  module_function
  def meaningless(n)
    return 1 if n == 0

    rational_sequence = RationalSequence.new(n)
    group_one = rational_sequence.select { |x| x.numerator.prime? or x.denominator.prime? }
    group_two = rational_sequence - group_one
    group_one.reduce(1, :*) / group_two.reduce(1, :*)
  end

  def aimless(n)
    return 0 if n == 0

    prime_sequence = PrimeSequence.new(n)
    even_indexed_numbers = prime_sequence.select.with_index { |_, index| index.even? }
    odd_indexed_numbers = prime_sequence - even_indexed_numbers
    odd_indexed_numbers << 1 if n.odd?

    rational_pairs = even_indexed_numbers.zip(odd_indexed_numbers)
    rational_sequence = rational_pairs.map { |pair| Rational(pair[0], pair[1]) }
    rational_sequence.reduce(0, :+)
  end

  def worthless(n)
    return [] if n == 0

    fibonacci_sequence = FibonacciSequence.new(n)
    maximum_sum = fibonacci_sequence[-1]
    current_number = 1
    largest_section = section = RationalSequence.new(current_number)
    sum = section.reduce(0, :+)
    while sum <= maximum_sum
      section = RationalSequence.new(current_number += 1)
      sum = section.reduce(0, :+)
      largest_section = section if sum <= maximum_sum
    end
    largest_section.to_a
  end
end

