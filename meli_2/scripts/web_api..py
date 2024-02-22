import pandas as pd
import json 
import requests as r
import sqlalchemy,pyodbc, pandas as pd
import os
from sqlalchemy import text
#Cria função para conectar no MYSQL

#processa dados da api principal chamando os itens
def process_api(key_list):
  for i in  key_list:
    print(i)
    dados = r.get(f"https://api.mercadolibre.com/sites/MLA/search?q={i}&limit=50#json")
    dados = json.loads(dados.text)
    df_final = pd.DataFrame(dados.get("results"))
    df_final.to_csv('api_stage.csv')
    process_item(dados)

def explode_df(df,lista):
  for i in lista:
    df.explode('buying_mode').reset_index(drop=True)
  return df


def process_item(dados):
  item = "id"
  lista = [return_item(f"https://api.mercadolibre.com/items/{i.get(item)}") for i in dados.get("results")]
  df_final = pd.DataFrame(lista)
  df_final = explode_df(df_final,['buying_mode', 'pictures', 'shipping', 'seller_address', 'listing_source','sale_terms']) 
  df_final.to_csv('api_item_stage.csv')

  

def main():
  #Cria conexão

  lista = ['appletv','chromecast','googlehome']
  process_api(lista)

if __name__ == "__main__":
  main()
