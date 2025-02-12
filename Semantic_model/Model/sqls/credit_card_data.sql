SELECT 
    Client_Num,
    Credit_Limit,
    Total_Trans_Amt,
    Avg_Utilization_Ratio,
    Total_Revolving_Bal,
    Delinquent_Acc,
    Week_Start_Date,
    
    -- Calculate Risk Score with values bounded between 0 and 1
    CASE 
        WHEN (10 * (
            0.4 * COALESCE(Avg_Utilization_Ratio, 0) + 
            0.3 * COALESCE(Total_Revolving_Bal, 0) / 10000 + 
            0.5 * COALESCE(Delinquent_Acc, 0) - 
            0.2 * COALESCE(Credit_Limit, 0) / 10000 - 
            0.1 * COALESCE(Total_Trans_Amt, 0) / 10000
        )) > 1 THEN 1  -- If value > 1, set to 1
        WHEN (10 * (
            0.4 * COALESCE(Avg_Utilization_Ratio, 0) + 
            0.3 * COALESCE(Total_Revolving_Bal, 0) / 10000 + 
            0.5 * COALESCE(Delinquent_Acc, 0) - 
            0.2 * COALESCE(Credit_Limit, 0) / 10000 - 
            0.1 * COALESCE(Total_Trans_Amt, 0) / 10000
        )) < 0 THEN 0  -- If value < 0, set to 0
        ELSE 
            (10 * (
                0.4 * COALESCE(Avg_Utilization_Ratio, 0) + 
                0.3 * COALESCE(Total_Revolving_Bal, 0) / 10000 + 
                0.5 * COALESCE(Delinquent_Acc, 0) - 
                0.2 * COALESCE(Credit_Limit, 0) / 10000 - 
                0.1 * COALESCE(Total_Trans_Amt, 0) / 10000
            ))
    END AS Risk_Score,

    -- Categorizing customers as risky if Risk_Score > 0.7
    CASE 
        WHEN 
            (10 * (
                0.4 * COALESCE(Avg_Utilization_Ratio, 0) + 
                0.3 * COALESCE(Total_Revolving_Bal, 0) / 10000 + 
                0.5 * COALESCE(Delinquent_Acc, 0) - 
                0.2 * COALESCE(Credit_Limit, 0) / 10000 - 
                0.1 * COALESCE(Total_Trans_Amt, 0) / 10000
            )) > 0.7 THEN 'Risky'
        ELSE 'Not Risky'
    END AS Risk_Category


FROM 
    lakehouse.siva.credit_data_cc
