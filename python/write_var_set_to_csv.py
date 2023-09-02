#extracting vars from variable set json in octopus and writing to csv
import json
import csv
import os

# Get list of all files in current directory
files = os.listdir()

# Filter for JSON files
json_files = [f for f in files if f.endswith('.json')]

# Loop through each JSON file
for json_file in json_files:
    json_file_name = json_file.split('.')[0]
    # Read the JSON data from the file
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Create a new CSV file name based on the JSON file name
    csv_file = json_file.replace('.json', '.csv')

    # Open the new CSV file to write the extracted data
    with open(csv_file, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        
        # Write the header
        csvwriter.writerow(['VarName', 'VarValue', 'Environment','VarSetName',])
        
        # Loop through the JSON data to extract 'Name' and 'Value' from the 'Variables' list
        for item in data[0]['Variables']:
            name = item['Name']
            value = item['Value']
            environment = ', '.join(item.get('Scope', {}).get('Environment', ''))
            if environment == '':
                environment = ', '.join(item.get('Scope', {}).get('TenantTag', ''))

            
            # Write the name and value to the CSV
            csvwriter.writerow([name, value, environment, json_file_name])

    print(f"Data from {json_file} has been written to {csv_file}")
