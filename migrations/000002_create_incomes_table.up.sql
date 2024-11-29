CREATE TABLE incomes
(
    id          SERIAL PRIMARY KEY,
    user_id     INT            NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    category_id INT,
    amount      NUMERIC(12, 2) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);
