SELECT
    CASE
        WHEN {{grouping_list}} = 'business unit' THEN business_unit
        WHEN {{grouping_list}} = 'product catalog' THEN product_catalog_code_stdr
        WHEN {{grouping_list}} = 'catalog group' THEN catalog_group
        WHEN {{grouping_list}} = 'payment provider' THEN payment_provider
        WHEN {{grouping_list}} = 'payment via' THEN payment_via
        WHEN {{grouping_list}} = 'partner product name' THEN partner_products_name
        WHEN {{grouping_list}} = 'va bank name' THEN va_bank_name
        WHEN {{grouping_list}} = 'voucher code' THEN voucher_code
        WHEN {{grouping_list}} = 'voucher title' THEN voucher_title
    END group_by,
    COUNT(DISTINCT id) as total_transactions,
    SUM(COUNT(DISTINCT id)) OVER () AS sum_payment_via,
    COUNT(DISTINCT id) * 1.00 /  SUM(COUNT(DISTINCT id)) OVER () AS percentage
FROM exploration_transaction_all
WHERE {{payment_period}}
    AND {{aquirement_type}}
    AND {{va_bank_name}}
    AND {{direct_bundle}}
    AND {{catalog_group}}
    AND {{use_voucher}}
    [[ AND LOWER(voucher_title) LIKE CONCAT('%',LOWER({{voucher_title}}), '%') ]]
    [[ AND LOWER(voucher_code) LIKE CONCAT('%', LOWER({{voucher_code}}), '%') ]]
    AND payment_status = 'success'
GROUP BY 1
ORDER BY 2 DESC
