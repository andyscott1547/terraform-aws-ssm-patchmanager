
def get_instance_ids_for_patch_group(ec2_client, patch_group_tag_value: str):
    '''Get EC2 instance IDs based on instances matching a filter (perhaps tags)'''
    # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/describe_instances.html
    instances = ec2_client.describe_instances(
        Filters=[
            {
                'Name': f'tag:PatchGroup',
                'Values': [
                    patch_group_tag_value
                ]
            }
        ]
    )
    instance_ids = []
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            instance_ids.append(instance_id)
    return instance_ids

def update_instance_tags(ec2_client, instance_ids, delete_patch_group_tag_value: str, replace_with_value: str):
    '''Update EC2 instance tags'''
    for instance_id in instance_ids:
        # delete tags
        # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/delete_tags.html
        ec2_client.delete_tags(
            Resources=[
                instance_id,
            ],
            Tags=[
                {
                    'Key': 'PatchGroup',
                    'Value': delete_patch_group_tag_value
                },
            ]
        )
        # replace deleted tags
        # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/create_tags.html
        ec2_client.create_tags(
            Resources=[
                instance_id,
            ],
            Tags=[
                {
                    'Key': 'PatchGroup',
                    'Value': replace_with_value
                },
            ]
        )
    return f'Completed updating tags for {delete_patch_group_tag_value}: {instance_ids}'