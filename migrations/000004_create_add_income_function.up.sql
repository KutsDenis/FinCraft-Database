CREATE OR REPLACE FUNCTION add_income(
    user_id INT,
    category_id INT,
    amount NUMERIC(12, 2),
    description TEXT
)
RETURNS TABLE (
    income_id INT,
    created_at TIMESTAMP
) AS $$
BEGIN
INSERT INTO incomes (user_id, category_id, amount, description, created_at)
VALUES (user_id, category_id, amount, description, NOW())
    RETURNING id AS income_id, created_at;
END;
$$ LANGUAGE plpgsql;
