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

  def list_user_debt(user_id)
    sql = <<~SQL
      SELECT name, amount, category_type, debt.id AS debt_id FROM debt 
      INNER JOIN debt_category ON category_id = debt_category.id
      WHERE user_id = $1
    SQL
    result = query(sql, user_id)

    result.map do |tuple|
      { name: tuple["name"],
        amount: add_commas(tuple["amount"]),
        category: tuple["category_type"],
        debt_id: tuple["debt_id"]}
    end
  end

  def calculate_debt(user_id)
    sql = <<~SQL
      SELECT SUM(amount) AS amount FROM debt 
      WHERE user_id = $1
      GROUP BY user_id
    SQL
    tuple = query(sql, user_id).first

    { amount: add_commas(tuple["amount"])}
  end

  def add_new_debt(title, amount, category, user_id)
    sql = "INSERT INTO debt (name, amount, category_id, user_id) VALUES ($1, $2, $3, $4)"
    query(sql, title, amount, category, user_id)
  end

  def find_debt(id)
    tuple = query("SELECT * FROM debt WHERE id = $1", id).first
    { title: tuple["name"],
      amount: tuple["amount"],
      user_id: tuple["user_id"],
      category_id: tuple["category_id"] }
  end

  def edit_debt(title, amount, category, id)
    sql = <<~SQL
      UPDATE debt
      SET name = $1,
          amount = $2,
          category_id = $3
      WHERE id = $4
    SQL
    query(sql, title, amount, category, id)
  end

  def delete_debt(id)
    query("DELETE FROM debt WHERE id = $1", id)
  end

  def list_user_savings(user_id)
    sql = <<~SQL
      SELECT name, amount_saved, category_type, saving_account.id AS account_id FROM saving_account 
      INNER JOIN saving_category ON category_id = saving_category.id
      WHERE user_id = $1
    SQL
    result = query(sql, user_id)

    result.map do |tuple|
      { name: tuple["name"],
        amount: add_commas(tuple["amount_saved"]),
        category: tuple["category_type"],
        account_id: tuple["account_id"] }
    end
  end

  def calculate_savings(user_id)
    sql = <<~SQL
      SELECT SUM(amount_saved) AS amount FROM saving_account 
      WHERE user_id = $1
      GROUP BY user_id
    SQL
    tuple = query(sql, user_id).first

    { amount: add_commas(tuple["amount"])}
  end

  def add_new_savings(title, amount, category, id)
    sql = "INSERT INTO saving_account (name, amount_saved, category_id, user_id) VALUES ($1, $2, $3, $4)"
    query(sql, title, amount, category, id)
  end

  def find_savings(id)
    tuple = query("SELECT * FROM saving_account WHERE id = $1", id).first
    { title: tuple["name"],
      amount: tuple["amount_saved"],
      user_id: tuple["user_id"],
      category_id: tuple["category_id"] }
  end

  def edit_savings(title, amount, category, id)
    sql = <<~SQL
      UPDATE saving_account
      SET name = $1,
          amount_saved = $2,
          category_id = $3
      WHERE id = $4
    SQL
    query(sql, title, amount, category, id)
  end

  def delete_savings(id)
    query("DELETE FROM saving_account WHERE id = $1", id)
  end
  
  private

  def query(statement, *params)
    @db.exec_params(statement, params)
  end

  def add_commas(num)
    num.reverse.scan(/\d{3}|.+/).join(",").reverse
  end
end