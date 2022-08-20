require "pg"

class DatabasePersistance
  def initialize
    @db = PG.connect(dbname: "budget")
  end

  def list_user_income(user_id)
    sql = "SELECT * FROM income WHERE user_id = $1"
    result = query(sql, user_id)

    result.map do |tuple|
      monthly_duration = tuple["duration"].to_i

      { title: tuple["title"],
        memo: tuple["memo"],
        monthly: add_commas(tuple["monthly_income"]),
        yearly: add_commas((tuple["monthly_income"].to_i * monthly_duration).to_s),
        income_id: tuple["id"] }
    end
  end

  def calculate_income(user_id)
    sql = <<~SQL
      SELECT SUM(monthly_income) AS total_month,
        SUM(monthly_income * 12) AS total_year
      FROM income 
      WHERE user_id = $1
      GROUP BY user_id
    SQL
    tuple = query(sql, user_id).first

    total_month = add_commas(tuple["total_month"])
    total_year = add_commas(tuple["total_year"])

    { month: total_month, year: total_year}
  end

  def add_new_income(title, memo, monthly_income, duration, user_id)
    sql = "INSERT INTO income VALUES (DEFAULT, $1, $2, $3, $4, $5)"
    query(sql, title, memo, monthly_income, duration, user_id)
  end

  def edit_income(title, memo, monthly_income, duration, id)
    sql = <<~SQL
      UPDATE income
      SET title = $1,
          memo = $2,
          monthly_income = $3,
          duration_months = $4
      WHERE id = $5
    SQL
    query(sql, title, memo, monthly_income, duration, id)
  end

  def find_income(id)
    tuple = query("SELECT * FROM income WHERE id = $1", id).first
    { title: tuple["title"],
      memo: tuple["memo"],
      monthly_income: tuple["monthly_income"],
      duration: tuple["duration_months"],
      user_id: tuple["app_user_id"] }
  end

  def delete_income(id)
    query("DELETE FROM income WHERE id = $1", id)
  end

  private

  def query(statement, *params)
    @db.exec_params(statement, params)
  end

  def add_commas(num)
    num.reverse.scan(/\d{3}|.+/).join(",").reverse
  end
end