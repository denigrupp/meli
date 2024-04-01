import json 
import requests as r
import pandas as pd
import joblib
from datetime import date
import s3fs


def return_item(url):
    """
    Function to extract data from url
    :param url: url path
    :return: json dict
    """
    values = r.get(url,verify=False)
    values = json.loads(values.text)
    return values

def explode_df(df,l):
    """
    Function to extract data from url
    :param df: pandas df
    :param l: list of itens to explode:
    :return: df pandas
    """
    for i in l:
      df.explode('buying_mode').reset_index(drop=True)
    return df

def authenticate_aws(json_path):
  """"
  Function to authenticate aws
  :param json_path: path to aws tokens
  """
  keys = open("aws.json", 'r')
  j = json.loads(keys.read())
  aws_access_key_id = j.get("aws_access_key_id")
  aws_secret_access_key = j.get("aws_secret_access_key")
  aws_session_token = j.get("aws_session_token")
  fs = s3fs.S3FileSystem(key=aws_access_key_id,
                       secret=aws_secret_access_key,
                       token =aws_session_token)
  return fs

def write_to_s3(df,path):
  fs = authenticate_aws("aws.json")
  with fs.open(path,mode='w') as f:
    df.to_csv(f)


def process_item(items,mla):
    """
    Function to extract itens  from api.mercadolibre.com/items
    uses joblib to parallelize api calls
    :param items: id from itens:
    """
    item = 'id'
    filename= f'item_{mla}_{date.today()}.csv'
    l = joblib.Parallel(n_jobs=2)(joblib.delayed(return_item)(f"https://api.mercadolibre.com/items/{i.get(item)}") 
                             for i in items.get("results"))
    df_final = pd.DataFrame(l)
    df_final = explode_df(df_final, ['buying_mode', 'pictures', 'shipping',
                                      'seller_address', 'listing_source','sale_terms']) 
    df_final.to_csv(filename)  
    write_to_s3(df_final,f'meli-denilson/{filename}')

#processa dados da api principal chamando os itens
def process_api(key_list):
  """
  Main function to process all api mercadolibre itens
  :param key_list: list of mla
  """
  for i in  key_list:
    filename= f'mla_{i}_{date.today()}.csv'
    dados = return_item(f"https://api.mercadolibre.com/sites/MLA/search?q={i}&limit=50#json")
    df_final = pd.DataFrame(dados.get("results"))
    df_final.to_csv(filename)
    write_to_s3(df_final,f'meli-denilson/{filename}')
    process_item(dados,i)  

def main():
  key_list = ['appletv', 'chromecast', 'googlehome']
  process_api(key_list)

if __name__ == "__main__":
  main()
