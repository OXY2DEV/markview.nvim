# Wide tables scrolled horizontally

Open with `:set nowrap` in a window narrower than the tables, then scroll right
with `zl` (or `20zl`). The borders, the separator row and every data row should keep
their `│` in the same screen columns at any scroll position.

## Plain cells

| Name | Kind | Size | Owner | Description of the thing |
|------|------|-----:|-------|--------------------------|
| alpha | x | 12 | bob | a fairly long description here so the table is wide |
| beta | y | 3 | alice | short |
| gamma | z | 450 | carol | another long description text that keeps going |

## Cells with markup and wide characters

| Chain | Ledger | Read | Write | Failure |
|---|---|---|---|---|
| **Hyperliquid HyperEVM** | HyperCore (external) | `0x800~0x810` one function each, `staticcall` | `CoreWriter 0x3333…3333` | **silent** |
| **Injective** | exchange module | `subaccountDeposit`, `subaccountPositions` | [docs](https://example.com/injective) | revert |
| *Sei* | bank 모듈 | `0x1001 balance`, `supply` | ~~sendNative~~ one call | 6dec↔18dec 변환 주의 |
