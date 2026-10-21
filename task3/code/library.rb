class LibraryItem
  # only readers, so the values cannot be changed from outside
  attr_reader :title, :author, :publication_year

  def initialize(title, author, publication_year)
    @title = title
    @author = author
    @publication_year = publication_year
  end

  def display_info
    puts
    puts "[#{item_type}]"
    puts "Title: #{@title}"
    puts "Year: #{@publication_year}"
  end

  def item_type
    "Item"
  end
end

class Book < LibraryItem
  attr_reader :genre

  def initialize(title, author, publication_year, genre)
    super(title, author, publication_year)
    @genre = genre
  end

  def display_info
    super
    puts "Author: #{@author}"
    puts "Genre: #{@genre}"
  end

  def item_type
    "Book"
  end
end

class DVD < LibraryItem
  attr_reader :genre

  def initialize(title, director, publication_year, genre)
    super(title, director, publication_year)
    @genre = genre
  end

  # for a DVD the "author" is the director
  def director
    @author
  end

  def display_info
    super
    puts "Director: #{director}"
    puts "Genre: #{@genre}"
  end

  def item_type
    "DVD"
  end
end

class CD < LibraryItem
  attr_reader :genre

  def initialize(title, artist, publication_year, genre)
    super(title, artist, publication_year)
    @genre = genre
  end

  # for a CD the "author" is the artist
  def artist
    @author
  end

  def display_info
    super
    puts "Artist: #{artist}"
    puts "Genre: #{@genre}"
  end

  def item_type
    "CD"
  end
end

class Library
  def initialize
    @items = []
  end

  def add_item(item)
    unless item.is_a?(LibraryItem)
      raise ArgumentError, "only library items can be added"
    end
    @items << item
    puts "Added: #{item.title}"
  end

  # removes the item with this title, returns it or nil if it is not there
  def remove_item(title)
    item = @items.find { |i| i.title == title }
    if item.nil?
      puts "Not found: #{title}"
    else
      @items.delete(item)
      puts "Removed: #{title}"
    end
    item
  end

  def display_item(item)
    item.display_info
  end

  def display_all_items
    if @items.empty?
      puts "The library is empty"
      return
    end
    puts "Library has #{@items.size} item(s):"
    @items.each { |item| display_item(item) }
  end
end

# Create instances of different library items
book = Book.new("Concepts of Programming Languages", "Robert Sebesta", 2015, "Programming")
dvd = DVD.new("Inception", "Christopher Nolan", 2010, "Science Fiction")
cd = CD.new("A Day at the Races", "Queen", 1976, "Rock")

# Display items individually
book.display_info
dvd.display_info
cd.display_info

# Create a library and add items to it
library = Library.new
library.add_item(book)
library.add_item(dvd)
library.add_item(cd)

# Display information about all items in the library
library.display_all_items

# my extra test
# removing an item
library.remove_item("Inception")
library.display_all_items