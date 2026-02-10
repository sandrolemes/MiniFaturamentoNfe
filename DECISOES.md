# Decisões Técnicas

## Arquitetura
Separação em camadas (DTO, DAO, Controller, Service, View) para facilitar
manutenção, clareza e rastreabilidade.

## ACBr
Utilizado apenas para montagem e geração do XML da NF-e, mantendo regras
de negócio fora do componente.

## Estados
Ciclo de vida da NF-e centralizado em constantes, evitando inconsistência.

## Simulação SEFAZ
Adotada para evitar dependência externa e permitir avaliação offline.

## IA
IA utilizada como apoio técnico, com revisão e decisão final humana.
