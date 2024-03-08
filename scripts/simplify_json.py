import json

def simplify_json(input_file, output_file):
    with open(input_file, 'r') as f:
        data = json.load(f)
    
    simplified_data = {}
    
    for item in data:
        state_name = item['municipio']['microrregiao']['mesorregiao']['UF']['nome']
        city_id = item['id']
        city_name = item['nome']
        
        if state_name in simplified_data:
            simplified_data[state_name]['cidades'].append({'id': city_id, 'nome': city_name})
        else:
            simplified_data[state_name] = {'uf': item['municipio']['microrregiao']['mesorregiao']['UF']['sigla'],
                                            'cidades': [{'id': city_id, 'nome': city_name}]}

    with open(output_file, 'w') as f:
        json.dump(simplified_data, f, separators=(',', ':'))

# Example usage:
input_file = '../lib/assets/brasil.json'
output_file = 'brasil.json'
simplify_json(input_file, output_file)