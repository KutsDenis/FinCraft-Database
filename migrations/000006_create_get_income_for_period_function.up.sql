CREATE FUNCTION get_incomes_for_period(
    p_user_id INT,
    p_start_date TIMESTAMP,
    p_end_date TIMESTAMP
)
RETURNS TABLE(category_id INT, amount NUMERIC(12,2), description TEXT) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = p_user_id) THEN
        RAISE EXCEPTION 'User with id % does not exist', p_user_id;
    END IF;

    IF p_end_date < p_start_date THEN
        RAISE EXCEPTION 'End date cannot be before start date';
    END IF;

    RETURN QUERY
    SELECT incomes.category_id, incomes.amount, incomes.description
    FROM incomes
    WHERE incomes.user_id = p_user_id
        AND created_at BETWEEN p_start_date AND p_end_date;
END;
$$ LANGUAGE plpgsql;