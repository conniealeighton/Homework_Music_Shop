require('pg')
require_relative('artist')


class Album


  attr_accessor :id, :artist_id, :title

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @artist_id = options['artist_id'].to_i()
  end


  def save()
    sql = "INSERT INTO albums (title, artist_id) VALUES ($1, $2) RETURNING id"
    values = [@title, @artist_id]
    results = SqlRunner.run(sql, values)
    @id = results[0]["id"].to_i
  end

  def self.create_new(album_name, artist_id)
    sql = "INSERT INTO albums (title, artist_id) VALUES ($1, $2) RETURNING id"
    values = [album_name, artist_id]
    results = SqlRunner.run(sql, values)
    @id = results[0]['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM albums"
    order_hashes = SqlRunner.run(sql)
    orders = order_hashes.map { |order| Album.new( order ) }
    return orders
  end


def self.find_by_artist(id_of_artist)
  sql = 'SELECT * FROM albums WHERE artist_id = $1'
  values = [id_of_artist]
  result_hash = SqlRunner.run(sql, values)
  result = result_hash.map { |album| Album.new( album )}
  return result
end

#should this method be in artists?

def self.find_by_album(id_of_album)
  sql = 'SELECT * FROM artists WHERE id = ($1)'
  values = [id_of_album]
  result_hash = SqlRunner.run(sql, values)
  result = result_hash.map { |artist| Artist.new( artist )}
  return result
end

def update()
  sql = "
  UPDATE albums SET title = $1 WHERE id = $2"
    values = [@title, @id]
    SqlRunner.run(sql, values)
end


def delete()
  sql = "DELETE FROM albums
  WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

def self.find(id)
  sql = "SELECT * FROM albums WHERE id = $1"
  values = [id]
  results = SqlRunner.run(sql, values)
  album_hash = results.first
  album = Album.new(album_hash)
  return album
end






end
