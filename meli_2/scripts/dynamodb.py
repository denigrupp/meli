import json 
import requests as r
import pandas as pd
import joblib
from datetime import date
import s3fs
import boto3
from decimal import Decimal

def return_item(url):
    """
    Function to extract data from url
    :param url: url path
    :return: json dict
    """
    values = r.get(url,verify=False)
    values = json.loads(values.text, parse_float=Decimal)
    return values


def authenticate_dynamo(json_path):
  """"
  Function to authenticate aws
  """
  keys = open(json_path, 'r')
  j = json.loads(keys.read())
  aws_access_key_id = j.get("aws_access_key_id")
  aws_secret_access_key = j.get("aws_secret_access_key")
  aws_session_token = j.get("aws_session_token")
  dynamodb = boto3.resource('dynamodb', aws_access_key_id=aws_access_key_id,
                        aws_secret_access_key=aws_secret_access_key,
                        aws_session_token=aws_session_token
                       ,region_name = "us-east-1", use_ssl=False)
  return dynamodb


def main():
  dynamodb = authenticate_dynamo("aws.json")
  table_name = 'meli2024'
  try:
     #Nome da tabela
  #Parametros de criação
    params = {
        'TableName': table_name, #nome da tabela
        #Esquema das chaves
        'KeySchema': [
            {'AttributeName': 'id', 'KeyType': 'HASH'}, # hash será a chave primaria
     #       {'AttributeName': 'nome', 'KeyType': 'RANGE'} #range, não obrigatória, formaria uma chave composta
        ],
        #Tipo de dados da chave
        'AttributeDefinitions': [
            {'AttributeName': 'id', 'AttributeType': 'S'}, #N de number
     #       {'AttributeName': 'nome', 'AttributeType': 'S'} #S de string
        ],
        #Configuração de escrita e leitura por segundo
        'ProvisionedThroughput': {
            'ReadCapacityUnits': 3,
            'WriteCapacityUnits': 3
        }
     }
    dynamodb.create_table(**params)
  except:
      print("Tabela já criada")
  
  table = dynamodb.Table(table_name)
  dados = return_item(f"https://api.mercadolibre.com/sites/MLA/search?q=chromecast#json").get("results")
  for i in dados:
     table.put_item(
        Item=i
     )
  


if __name__ == "__main__":
  main()