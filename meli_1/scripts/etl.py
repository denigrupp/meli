import sqlalchemy,pyodbc, pandas as pd
import os
from sqlalchemy import text
#Cria função para conectar no MYSQL
def conect_mysql(servidor:str,
                 banco:str,
                 usuario:str,
                 senha:str):  
  string_conexao = f'mysql://{usuario}:{senha}@{servidor}/{banco}'
  engine = sqlalchemy.create_engine(string_conexao) 
  return engine
def upload_csv(path,table):
  df = pd.read_csv(path)
  df.to_sql(table,engine,if_exists='replace',index=False)
  print(f"tabela {table} uploaded")


def main():
  #Cria conexão
  engine = conect_mysql(
    servidor = 'meli.c1uikg0o2ejy.us-east-1.rds.amazonaws.com',
    banco = 'SELLER' ,                    
    usuario = 'aluno',
    senha = 'aluno123'
    )
  #Grava dados no BD
  path = '/content/meli'
  for i in os.listdir(path):
    path_table = path + '/' + i
    table = i.replace(".csv","").upper()
    upload_csv(path_table,table)
if __name__ == "__main__":
  main()