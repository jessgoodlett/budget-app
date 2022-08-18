/* for development, to reset database */
DROP TABLE IF EXISTS public.user;
DROP TABLE IF EXISTS public.income;
DROP TABLE IF EXISTS public.expense_category;
DROP TABLE IF EXISTS public.expense;
DROP TABLE IF EXISTS public.spending;
DROP TABLE IF EXISTS public.saving_category;
DROP TABLE IF EXISTS public.saving_account;
DROP TABLE IF EXISTS public.debt_category;
DROP TABLE IF EXISTS public.debt;

CREATE TABLE app_user (
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
  memo TEXT,
  monthly_amount REAL NOT NULL,
  duration_months INTEGER NOT NULL,
  user_id INTEGER REFERENCES "user"(id)
);

CREATE TABLE expense_category (
  id SERIAL PRIMARY KEY,
  category_type TEXT NOT NULL
);

CREATE TABLE expense (
  name TEXT NOT NULL,
  amount_spent REAL NOT NULL,
  required BOOLEAN DEFAULT true,
  user_id INTEGER REFERENCES "user"(id),
  category_id INTEGER REFERENCES expense_category(id)
);

CREATE TABLE spending (
  item TEXT NOT NULL,
  cost REAL NOT NULL,
  expense_category_id INTEGER REFERENCES expense_category(id)
);

CREATE TABLE saving_category (
  id SERIAL PRIMARY KEY,
  category_type TEXT NOT NULL
);

CREATE TABLE saving_account (
  name SERIAL PRIMARY KEY,
  amount_saved REAL NOT NULL,
  user_id INTEGER REFERENCES "user"(id),
  category_id INTEGER REFERENCES saving_category(id)
);

CREATE TABLE debt_category (
  id SERIAL PRIMARY KEY,
  category_type TEXT NOT NULL
);

CREATE TABLE debt (
  name TEXT NOT NULL,
  amount REAL NOT NULL,
  interest_rate NUMERIC(6, 4),
  user_id INTEGER REFERENCES "user"(id),
  category_id INTEGER REFERENCES debt_category(id)
);

/* Data for development -- User and income */
INSERT INTO "user" (first_name, last_name, username, password, email) 
  VALUES ('Jane', 'Doe', 'toobroke', 'secret', 'janedoe@broke.com');

INSERT INTO income VALUES ('software engineer', 'full-time position' 5000, 12, 1);
INSERT INTO income VALUES ('freelance developer', 'contract work. estimated yearly.' 2000, 12, 1);
