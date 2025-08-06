import pylatex as pl
import pandas as pd
tables = ['table_sem_pca', 'table_pca_sem_red', 'table_pca_red', 'table_pca_box']
for table in tables:
    df = pd.read_csv(f'{table}.txt')

    tb = pl.Tabular('|' + 'c|' * len(df.columns))
    tb.add_hline()
    col = ['Classificador', 'Média', 'Mínimo', 'Máximo', 'Mediana', 'Desvio', 'Tempo de']
    col = [pl.utils.bold(c) for c in col]
    col = [pl.MultiRow(2, data=c) for c in col[:-2]] + col[-2:]
    col2 = [''] * 5 + [pl.utils.bold('Padrão'), pl.utils.bold('Execução (s)')]
    tb.add_row(col)
    tb.add_row(col2)
    tb.add_hline()
    tb.add_hline()
    for index, row in df.iterrows():
        tb.add_row([f'{val:.3f}' if isinstance(val, float) else pl.utils.bold(val) for val in row])
        tb.add_hline()
    tb.add_hline()
    with open(f'../texs/{table}.tex', 'w') as f:
        f.write(tb.dumps())

for i in range(1,3):
    table = 'model'+str(i)
    df = pd.read_csv(f'{table}.txt')
    tb = pl.Tabular('|' + 'c|' * len(df.columns))
    tb.add_hline()
    col = ['Métrica', 'Média', 'Desvio Padrão']
    col = [pl.utils.bold(c) for c in col]
    tb.add_row(col)
    tb.add_hline()
    for index, row in df.iterrows():
        tb.add_row([f'{100*val:.1f}' if isinstance(val, float) else pl.utils.bold(val) for val in row])
        tb.add_hline()
    with open(f'../texs/{table}.tex', 'w') as f:
        f.write(tb.dumps())
