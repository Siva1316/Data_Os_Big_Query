SELECT 
    Client_Num,
    Credit_Limit,
    Total_Trans_Amt,
    Avg_Utilization_Ratio,
    Total_Revolving_Bal,
    Delinquent_Acc,
    
    -- Calculate Risk Score
    (0.4 * Avg_Utilization_Ratio + 
     0.3 * Total_Revolving_Bal + 
     0.5 * Delinquent_Acc - 
     0.2 * Credit_Limit - 
     0.1 * Total_Trans_Amt) AS Risk_Score,
    
    -- Categorizing customers as risky based on threshold, considering greater than 70% as risk.
    CASE 
        WHEN (0.4 * Avg_Utilization_Ratio + 
              0.3 * Total_Revolving_Bal + 
              0.5 * Delinquent_Acc - 
              0.2 * Credit_Limit - 
              0.1 * Total_Trans_Amt) > 0.7 THEN 'Risky'
        ELSE 'Not Risky'
    END AS Risk_Category

FROM 
    lakehouse.siva.credit_data_cc;
