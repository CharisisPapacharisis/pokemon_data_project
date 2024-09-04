import boto3

def lambda_handler(event, context):

    s3 = boto3.client('s3')

    source_bucket = 'charisis-sftp-bucket'
    
    destination_bucket = 'charisis-data-lake'
    destination_prefix = 'manual_files/'  

    try:
        # List all objects in the source bucket
        response = s3.list_objects_v2(Bucket=source_bucket)
 
        # Check if the bucket is not empty
        if 'Contents' in response:
            for obj in response['Contents']:
                source_key = obj['Key']
                print(source_key)
                
                # create the destination key
                destination_key = destination_prefix + source_key

                # copy object from source bucket to destination bucket
                source = {'Bucket': source_bucket, 'Key': source_key}
                
                s3.copy_object(
                    CopySource=source,
                    Bucket=destination_bucket,
                    Key=destination_key
                )

                print(f"File '{source_key}' copied to '{destination_bucket}/{destination_key}'")

        else:
            print("Source bucket is empty. No files to copy.")

    except:
      print("An exception occurred")