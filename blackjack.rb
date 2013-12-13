class Card
  attr_accessor :suit, :value

  def initialize(s, v)
    @suit = s
    @value = v 
  end
end

class Deck
  attr_accessor :deck 

  def initialize
    @deck = []
    ['Hearts', 'Diamonds', 'Clubs', 'Spades'].each do |s|
      [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace'].each do |v|
        @deck.push(Card.new(s, v))
      end
    end
    shuf
  end

  def deal
    @deck.pop
  end

  def shuf
    @deck.shuffle!
  end
  protected :shuf
end

module Summable
  def calculate_total(cards)
    prev_ace = 0
    total = 0

    cards.each do |c|
      if c.value == "Jack"
        total = total + 10
      elsif c.value == "Queen"
        total = total + 10
      elsif c.value == "King"
        total = total + 10
      elsif c.value == "Ace"
        prev_ace += 1
      else
        total = total + c.value.to_i
      end
    end

    prev_ace.times do 
      if (total + 11) > 21
        total += 1
      else
        total += 11
      end
    end

  total
  end
end

module Playable
  def initial_cards(deck)
    2.times do 
      cards << deck.deal
    end
  end

  def bust_or_win?(total)
    win = false
    bust = false
    if total == 21
      win = "win"
    elsif total > 21
      bust = "lost"
    end
  end

  def hit_or_stay?(deck)
    while true
      puts "Would you like to Hit or Stay"
      ans = gets.chomp.downcase
      if ans == "hit"
        cards << deck.deal
        break
      elsif ans == "stay"
        break
      else
        next
      end
    end
    ans
  end

  def play_again?
    playing = false
    while true
      puts "Would you like to play again? yes or no"
      ans = gets.chomp.downcase
      if ans == "yes"
        playing = true
        break
      elsif ans == "no"
        playing = false
        break
      else
        next
      end
    end
    playing
  end

  def print_dealing
    count = 0
    print "Dealing"
    while count < 10
      print "."
      count += 1
      sleep(0.2)
    end
    print "\n"
  end

  def win_or_lost?(total)
    if bust_or_win?(total) == 'win'
      puts "You win!"
      playing
    elsif bust_or_win?(total) == 'lost'
      puts "You lost"
      playing
    end
  end

  def playing
    if play_again?
      reset
    else
      puts "Great Game!"
      exit
    end
  end
end

class Player
  attr_accessor :name, :cards
  include Summable
  include Playable
  def initialize(name='Player')
    @name = name
    @cards = []
  end

  def player_print(total)
    puts "#{@name} has the following:"
    cards.each do |c|
      puts "===> #{c.value} of #{c.suit}" 
    end
    puts "For a total of: #{total}"
    puts ""
  end
end

class Dealer
  attr_accessor :name, :cards
  include Summable
  include Playable
  def initialize(name='Dealer')
    @name = name
    @cards = []
  end

  def dealer_print(total)
    puts "The Dealer has the following:"
    cards.each do |c|
      puts "===> #{c.value} of #{c.suit}" 
    end
    puts "For a total of: #{total}"
    puts ""
  end
end

class Game
  include Playable
  attr_accessor :player_total, :dealer_total, :name
  def initialize(name)
    @name = name
    @player = Player.new(name)
    @dealer = Dealer.new
    @deck = Deck.new
    @player_total = 0
    @dealer_total = 0
    puts "Hello, #{name}, lets play some blackjack!"
  end

  def total
    @player_total = @player.calculate_total(@player.cards)
    @dealer_total = @dealer.calculate_total(@dealer.cards)
  end

  def reset
    @player = Player.new(name)
    @dealer = Dealer.new
    @deck = Deck.new
    @player_total = 0
    @dealer_total = 0
    puts `clear`
    start_game
  end

  def start_game
    print_dealing
    @player.initial_cards(@deck)
    @dealer.initial_cards(@deck)
    total
    @player.player_print(@player_total)
    @dealer.dealer_print(@dealer_total)
    win_or_lost?(@player_total)
    win_or_lost?(@dealer_total)

    while @player.hit_or_stay?(@deck) == "hit"
      total
      @player.player_print(@player_total)
      win_or_lost?(@player_total)
    end
    puts ""

    while @dealer_total <= @player_total
      puts "The dealer is drawing"
      @dealer.cards << @deck.deal
      total
      @dealer.dealer_print(@dealer_total)
      if @dealer_total > @player_total && @dealer_total <= 21
        puts "You lost! Dealer now has #{@dealer_total}"
        playing
        break
      end
    end
    puts "The dealer busted!"
    puts "You won!"
    playing
  end
end

#game start
g = Game.new('Adam')
g.start_game
