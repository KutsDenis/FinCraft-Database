CREATE OR REPLACE FUNCTION get_income_for_period(
    p_user_id INT,
    p_start_date TIMESTAMP,
    p_end_date TIMESTAMP
)
RETURNS NUMERIC(12,2) AS $$
DECLARE 
    total_income NUMERIC(12,2);
BEGIN
    SELECT SUM(amount)
    INTO total_income
    FROM incomes
    WHERE user_id = p_user_id
        AND created_at BETWEEN p_start_date AND p_end_date;
    RETURN total_income;
END;
$$ LANGUAGE plpgsql;
