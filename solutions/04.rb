class Card
  include Comparable

  attr_accessor :rank, :suit
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{@rank.to_s.capitalize} of #{@suit.to_s.capitalize}"
  end

  def ==(other)
    return false if other == nil
    @rank == other.rank and @suit == other.suit
  end

end

class Deck
  class Hand
    def initialize(cards = [])
      @cards = cards
    end

    def size
      @cards.size
    end

    def add_card(card)
      @cards << card
    end
  end

  include Enumerable
  SUITS = [:clubs, :diamonds, :hearts, :spades]

  def standard_cards
     SUITS.product(self.ranks).collect { |suit, rank| Card.new(rank, suit) }
  end

  def initialize(cards = standard_cards)
    @cards = cards.dup
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.first
  end

  def bottom_card
    @cards.last
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort_by! { |card| [SUITS.index(card.suit), ranks.index(card.rank)] }
    @cards.reverse!
  end

  def to_a
    @cards
  end

  def to_s
    @cards.each { |card| p card.to_s }
  end

  def ranks
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  end
end

class WarDeck < Deck
  class WarHand < Deck::Hand
    def play_card
      @cards.pop
    end

    def allow_face_up?
      @cards.size <= 3
    end
  end

  def deal
    hand = WarHand.new
    while hand.size < 26
      hand.add_card(self.draw_top_card)
    end
    hand
  end
end

class BeloteDeck < Deck
  class BeloteHand < Deck::Hand
    def highest_of_suit(suit)
      deck_from_hand = BeloteDeck.new(@cards.select { |card| card.suit == suit })
      deck_from_hand.sort
      deck_from_hand.draw_top_card
    end

    def belote?
      kings_and_queens = @cards.select { |card| king_or_queen(card) }
      grouped_cards = kings_and_queens.group_by { |card| card.suit }
      grouped_cards.any? { |_, value| value.size == 2 }
    end

    def next_card(card)
      belote_deck_cards = BeloteDeck.new.to_a
      found_card = belote_deck_cards.first

      belote_deck_cards.each do |deck_card|

        if deck_card == card
          found_card = deck_card
          break
        end

      end
      card_index = belote_deck_cards.index(found_card)
      belote_deck_cards[card_index + 1]
    end

    def tierce?
      return false if @cards.size < 3
      deck_from_hand = BeloteDeck.new(@cards)
      deck_from_hand.sort
      hand = deck_from_hand.to_a

      hand.each_cons(3) do |first, second, third|
        return true if consecutive_three?(first, second, third)
      end

      false
    end

    def quarte?
      return false if @cards.size < 4
      deck_from_hand = BeloteDeck.new(@cards)
      deck_from_hand.sort
      hand = deck_from_hand.to_a

      hand.each_cons(4) do |first, second, third, fourth|
        return true if consecutive_four?(first, second, third, fourth)
      end

      false
    end

    def quint?
      return false if @cards.size < 5
      deck_from_hand = BeloteDeck.new(@cards).sort
      hand = deck_from_hand.to_a

      hand.each_cons(5) do |first, second, third, fourth, fifth|
        has_quart = consecutive_four?(first, second, third, fourth)
        has_quint = has_quart and fourth == next_card(fifth)
        return true if has_quint
      end

      false
    end

    def carre_of_jacks?
      four_of_a_rank(:jack)
    end

    def carre_of_nines?
      four_of_a_rank(9)
    end

    def carre_of_aces?
      four_of_a_rank(:ace)
    end

    def consecutive_three?(first, second, third)
        first == next_card(second) and second == next_card(third)
    end

    def consecutive_four?(first, second, third, fourth)
      consecutive_three?(first, second, third) and third == next_card(fourth)
    end

    private

    def four_of_a_rank(rank)
      @cards.select { |card| card.rank == rank }.size == 4
    end

    def king_or_queen(card)
      card.rank == :king or card.rank == :queen
    end
  end

  def ranks
    [7, 8, 9, :jack, :queen, :king, 10, :ace]
  end

  def deal
    hand = BeloteHand.new
    while hand.size < 8
      hand.add_card(self.draw_top_card)
    end
    hand
  end
end



class SixtySixDeck < Deck
  class SixtySixHand < Deck::Hand
    def twenty?(trump_suit)
      kings_and_queens = @cards.select { |card| king_or_queen(card) }
      groups = kings_and_queens.group_by { |card| card.suit }
      pairs = groups.select { |key, value| twenty_pair?(key, value, trump_suit) }
      pairs.size > 0
    end

    def forty?(trump_suit)
      kings_and_queens = @cards.select { |card| king_or_queen(card)  }
      groups = kings_and_queens.group_by { |card| card.suit }
      pairs = groups.select { |key, value| forty_pair?(key, value, trump_suit) }
      pairs.size > 0
    end

    def twenty_pair?(key, value, trump_suit)
      key !=  trump_suit and value.size == 2
    end

    def forty_pair?(key, value, trump_suit)
      key == trump_suit and value.size == 2
    end

    def king_or_queen(card)
      card.rank == :king or card.rank == :queen
    end
  end
  def ranks
    [9, :jack, :queen, :king, 10, :ace]
  end

  def deal
     hand = SixtySixHand.new
     while hand.size < 6
       hand.add_card(self.draw_top_card)
     end
     hand
  end
end

