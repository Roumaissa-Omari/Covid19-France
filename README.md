# Projet académique sur la Covid19-France
Analyse descriptive et diagnostique de l’évolution de la pandémie grâce au données hospitalières en France en Python (Numpy, Pandas ,Matplotlib).

Les données proviennent des dataset mis à disposition par le gouvernement sur data.gouv.fr , j'ai choisi de joindre deux dataset relatifs au données sanitaires : 
   -Données hospitalières relatives à l'épidémie de COVID-19 ( https://www.data.gouv.fr/fr/datasets/donnees-hospitalieres-relatives-a-lepidemie-de-covid-19/) 
   -Données des urgences hospitalières et de SOS Médecins relatives à l'épidémie de COVID-19 (https://www.data.gouv.fr/fr/datasets/donnees-des-urgences-hospitalieres-et-de-sos-medecins-relatives-a-lepidemie-de-covid-19/)


En première partie :
Des requêtes sql grâce à la bibliothèque Sqlite3 permettant de récupérer : 
-les Régions et départements les plus touchées par nombre d'hospitalisation 
 
-Les classes d’âge les plus touchées 
-Les jours de la semaine ayant le plus de cas covid19 confirmés
-la répartition par sexe des cas covid19

En deuxième partie : 
Une visualisation graphiques des statistiques covid19 à l'aide des bibliothèque seaborn , matplotlib 

En troisième partie : 
Une visualisation des cluster covid par Map interactif à l'aide de la bibliothèque folium

![image](https://user-images.githubusercontent.com/64476111/114394545-9cedd300-9b9b-11eb-8365-8c2a39a08a48.png)

![image](https://user-images.githubusercontent.com/64476111/114394573-a5460e00-9b9b-11eb-8fff-0d473970bd93.png)

![image](https://user-images.githubusercontent.com/64476111/114394604-ac6d1c00-9b9b-11eb-886f-15640a9877d0.png)
![image](https://user-images.githubusercontent.com/64476111/114394632-b4c55700-9b9b-11eb-91ac-cf83f7d677df.png)





