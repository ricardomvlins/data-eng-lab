-- Passo 5 (28/10): primeira tabela de staging, carga manual idempotente e variação diária.
-- Valores FICTÍCIOS, só para praticar. Os reais virão da API do Banco Central (série 1).

-- 1) Tabela: uma linha por dia útil.
CREATE TABLE IF NOT EXISTS staging.cotacao_dolar (
    data  date          PRIMARY KEY,  -- a data é a chave: não pode repetir
    valor numeric(10,4) NOT NULL      -- numeric é exato (bom para dinheiro); 4 casas como na API
);

-- 2) Carga com upsert: se a data já existe, atualiza o valor em vez de duplicar.
--    Rode este bloco duas vezes e confira que a tabela continua com 5 linhas.
INSERT INTO staging.cotacao_dolar (data, valor) VALUES
    ('2026-10-20', 5.4012),
    ('2026-10-21', 5.4237),
    ('2026-10-22', 5.3985),
    ('2026-10-23', 5.4110),
    ('2026-10-26', 5.4402)   -- 24 e 25 são fim de semana: a API não traz
ON CONFLICT (data) DO UPDATE
    SET valor = EXCLUDED.valor;   -- EXCLUDED = a linha que tentou entrar

-- 3) Variação em relação ao dia útil anterior.
SELECT
    data,
    valor,
    LAG(valor) OVER (ORDER BY data)          AS valor_anterior,
    valor - LAG(valor) OVER (ORDER BY data)  AS variacao,
    ROUND((valor / LAG(valor) OVER (ORDER BY data) - 1) * 100, 2) AS variacao_pct
FROM staging.cotacao_dolar
ORDER BY data;
