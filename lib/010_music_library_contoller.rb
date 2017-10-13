require 'pry'
class MusicLibraryController

  def initialize(path = './db/mp3s')
    MusicImporter.new(path).import
  end

  def call
    input = nil

    until input == "exit" do
      puts "Welcome to your music library!"
      puts "To list all of your songs, enter 'list songs'."
      puts "To list all of the artists in your library, enter 'list artists'."
      puts "To list all of the genres in your library, enter 'list genres'."
      puts "To list all of the songs by a particular artist, enter 'list artist'."
      puts "To list all of the songs of a particular genre, enter 'list genre'."
      puts "To play a song, enter 'play song'."
      puts "To quit, type 'exit'."
      puts "What would you like to do?"
      input = gets.strip

      if input == 'list songs'
        list_songs
      elsif input == 'list artists'
        list_artists
      elsif input == 'list genres'
        list_genres
      elsif input == 'list artist'
        list_songs_by_artist
      elsif input == 'list genre'
        list_songs_by_genre
      elsif input == 'play song'
        play_song
      end
    end
  end

  def list_songs
    alphabetized_songs.each.with_index(1) do |song, index|
      puts "#{index}. #{song.artist.name} - #{song.name} - #{song.genre.name}"
    end
  end

  def list_artists
    Artist.all.sort_by do |object|
      object.name
    end.each.with_index(1) do |artist, index|
      puts "#{index}. #{artist.name}"
    end
  end

  def list_genres
    Genre.all.sort_by do |object|
      object.name
    end.each.with_index(1) do |genre, index|
      puts "#{index}. #{genre.name}"
    end
  end

  def list_songs_by_artist
    puts "Please enter the name of an artist:"
    input = gets.strip

    Song.all.map do |song|
      song if song.artist.name == input
    end.compact.sort_by do |song|
      song.name
    end.each.with_index(1) do |song, index|
      puts "#{index}. #{song.name} - #{song.genre.name}"
    end
  end

  def list_songs_by_genre
    puts "Please enter the name of a genre:"
    input = gets.strip

    Song.all.map do |song|
      song if song.genre.name == input
    end.compact
    alphabetized_songs.each.with_index(1) do |song, index|
      puts "#{index}. #{song.artist.name} - #{song.name}"
    end
  end

  def play_song
    puts "Which song number would you like to play?"
    input = gets.strip.to_i

    song = alphabetized_songs[input - 1]
    if input < alphabetized_songs.size && input > 0
      puts "Playing #{song.name} by #{song.artist.name}"
    end
  end

  def alphabetized_songs
    @alphabetized_songs ||= Song.all.sort_by {|song| song.name}
  end

end
# .sort_by do |song|
#   song.name
# end.