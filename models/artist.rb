require('pg')
require_relative('../db/sql_runner')



class Artist

  attr_reader :id
  attr_accessor :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO artists (name) VALUES ($1) RETURNING id"
    values = [@name]
    results = SqlRunner.run(sql, values)
    @id = results[0]["id"].to_i
  end

  def self.create_new(new_artist)
    sql = "INSERT INTO artists (name) VALUES ($1) RETURNING id"
    values = [new_artist]
    results = SqlRunner.run(sql, values)
    @id = results[0]['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM artists"
    order_hashes = SqlRunner.run(sql)
    orders = order_hashes.map { |order| Artist.new( order ) }
    return orders
  end

  def update()
    sql = "
    UPDATE artists SET name = $1 WHERE id = $2"
      values = [@name, @id]
      SqlRunner.run(sql, values)
  end


  def self.find(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    artist_hash = results.first
    artist = Artist.new(artist_hash)
    return artist
  end



end
