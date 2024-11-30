CREATE OR REPLACE FUNCTION add_income(
    p_user_id INT,
    p_category_id INT,
    p_amount NUMERIC(12, 2),
    p_description TEXT
)
    RETURNS VOID AS $$
BEGIN
    INSERT INTO incomes (user_id, category_id, amount, description, created_at)
    VALUES (p_user_id, p_category_id, p_amount, p_description, NOW());
END;
$$ LANGUAGE plpgsql;
