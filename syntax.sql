-- Data Mart --
CREATE TABLE kimia_farma.Tabel_Analisis_1 AS
SELECT
t.transaction_id,
t.date,
t.branch_id,
c.branch_name,
c.kota,
c.provinsi,
c.rating,
t.customer_name,
t.product_id,
i.product_name,
t.price AS actual_price,
t.discount_percentage,
CASE
  WHEN t.price <=50000 THEN 0.1
  WHEN t.price > 50000 AND t.price <=100000 THEN 0.15
  WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
  WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
  WHEN t.price > 500000 THEN 0.3
END AS persentase_gross_laba,
t.price -(t.price*t.discount_percentage) AS nett_sales,
(t.price -(t.price*t.discount_percentage))*
CASE
  WHEN t.price <= 50000 THEN 0.1
  WHEN t.price > 50000 AND t.price <=100000 THEN 0.15
  WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
  WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
  WHEN t.price > 500000 THEN 0.3
END AS nett_profit,
t.rating AS rating_transaksi
FROM
  `kimia_farma.kf_final_transaction` as t
  LEFT JOIN `kimia_farma.kf_inventory` as i ON t.branch_id = i.branch_id AND t.product_id = i.product_id
  LEFT JOIN `kimia_farma.kf_kantor_cabang` as c ON t.branch_id = c.branch_id
  LEFT JOIN `kimia_farma.kf_product` as p ON t.product_id = p.product_id;

-- Delete Row dengan Null--
DELETE FROM kimia_farma.Tabel_Analisis
WHERE product_name IS NULL;