require "pg"

class DatabasePersistance
  def initialize
    @db = PG.connect(dbname: "budget")
  end

  def list_user_income(user_id)
    sql = "SELECT * FROM income WHERE user_id = $1"
    result = query(sql, user_id)

    result.map do |tuple|
      { name: tuple["name"],
        description: tuple["description"],
        monthly: add_commas(tuple["monthly_amount"]),
        yearly: add_commas((tuple["monthly_amount"].to_i * 12).to_s) }
    end
  end

  def calculate_income(user_id)
    sql = <<~SQL
      SELECT SUM(monthly_amount) AS total_month,
        SUM(monthly_amount * 12) AS total_year
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
    sql = "INSERT INTO income VALUES ($1, $2, $3, $4, $5)"
    query(sql, title, memo, monthly_income, duration, user_id)
  end

  private

  def query(statement, *params)
    @db.exec_params(statement, params)
  end

  def add_commas(num)
    num.reverse.scan(/\d{3}|.+/).join(",").reverse
  end
end