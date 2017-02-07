require_relative = 'play_db_connection'

class PlayWright

  attr_accessor :id, :name, :birth_year

  def self.all
    PlayDBConnection.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        playwrights
    SQL
  end

  def self.find_by_name(name)
    PlayDBConnection.instance.execute(<<-SQL, name)
      SELECT
        *
      FROM
        playwrights
      WHERE
        name = ?
    SQL
  end

  def initialize(options)
    @id = options["id"]
    @name = options["name"]
    @birth_year = options["birth_year"]
  end

  def create
    raise "Duplicate Entry" if @id
    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year)
      INSERT INTO
        playwrights (name, birth_year)
      VALUES
        (?, ?)
    SQL
    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "Playwright does not exist" unless @id
    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year, @id)
      UPDATE
        playwrights
      SET
        name = ?, birth_year = ?
      WHERE
        id = ?
    SQL
  end

  def get_plays
    # should return all plays written by a playwright
    PlayDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        title
      FROM
        playwrights
        JOIN
          plays
        ON
          playwrights.id = plays.playwright_id
      WHERE
        playwright_id = ?
    SQL
  end

end
