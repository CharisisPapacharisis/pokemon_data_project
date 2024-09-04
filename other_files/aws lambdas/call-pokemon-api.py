import json
import requests
import boto3


s3 = boto3.client('s3')

def lambda_handler(event, context):

    parameter_list = {
        'females' : 1,
        'males' : 2, 
        'unspeficied' : 3
    }
    
    base_url = "https://pokeapi.co/api/v2/gender/"
    

    for key,value in parameter_list.items():
    
        full_url = base_url+str(value)
        response = requests.get(full_url)
        
        if response.status_code == 200:
            data = response.json()
    
            # Convert the result to JSON format
            result_json = json.dumps(data)
            print("result_json :", result_json)
        
            bucket_name = "charisis-data-lake" 
            filename = f"api_data/{key}.json"
        
            s3.put_object(Bucket=bucket_name, Key=filename, Body=result_json)
        
            print("Data written successfully to s3")
    
        
        else:
            print("Faled to get data")    