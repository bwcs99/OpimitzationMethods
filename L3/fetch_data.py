#Błażej Wróbel, 250070, 4. rok, W4N, informatyka algorytmiczna
# Prosty skrypt do ściągania danych testowych ze strony
import requests

files = []

for i in range(5, 13):
	files.append(f'gap{i}.txt')
	
files += [f'gapa.txt', f'gapb.txt', f'gapc.txt', f'gapd.txt']

for fil in files:
	link = f'http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/{fil}'
	
	link_contents = requests.get(link)
	
	with open(f'{fil}', 'w') as file_to_write:
		file_to_write.write(link_contents.text)
	
	print(f'Pomyślnie zapisano plik {fil} !') 
