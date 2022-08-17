CREATE TABLE user (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  email TEXT NOT NULL,
  created_account_date DATE DEFAULT now()
);

CREATE TABLE income (
  name TEXT NOT NULL,
  monthly_amount REAL NOT NULL,
  user_id INTEGER REFERENCES user(id)
);

CREATE TABLE expense (
  name TEXT NOT NULL,
  amount_spent REAL NOT NULL,
  required BOOLEAN DEFAULT true,
  user_id INTEGER REFERENCES user(id),
  category_id INTEGER REFERENCES expense_category(id)
);

CREATE TABLE spending (
  item TEXT NOT NULL,
  cost REAL NOT NULL,
  expense_category_id INTEGER REFERENCES expense_category(id)
);

CREATE TABLE expense_category (
  id SERIAL PRIMARY KEY,
  category_type TEXT NOT NULL
);

CREATE TABLE saving_account (
  name SERIAL PRIMARY KEY,
  amount_saved REAL NOT NULL,
  user_id INTEGER REFERENCES user(id),
  category_id INTEGER REFERENCES saving_category(id)
);

CREATE TABLE saving_category (
  id SERIAL PRIMARY KEY,
  category_type TEXT NOT NULL
);

CREATE TABLE debt (
  name TEXT NOT NULL,
  amount REAL NOT NULL,
  interest_rate NUMERIC(6, 4),
  user_id INTEGER REFERENCES user(id),
  category_id INTEGER REFERENCES debt_category(id)
);

CREATE TABLE debt_category (
  id SERIAL PRIMARY KEY,
  category_type TEXT NOT NULL
);
