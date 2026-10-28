-- Roda sozinho na primeira subida do Postgres (só com o volume vazio).
CREATE SCHEMA IF NOT EXISTS staging;    -- dados como chegam da API do Banco Central
CREATE SCHEMA IF NOT EXISTS analytics;  -- dados tratados (fato e dimensões)
