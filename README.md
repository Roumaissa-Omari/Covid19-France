# Projet académique sur la Covid19-France
Analyse descriptive et diagnostique de l’évolution de la pandémie grâce au  données hospitalières en France en Python (Numpy, Pandas ,Matplotlib).

Les données proviennent des dataset mis à disposition par le gouvernement sur data.gouv.fr , j'ai choisit de joindre deux dataset relatifs au données sanitaires : 
   -Données hospitalières relatives à l'épidémie de COVID-19 ( https://www.data.gouv.fr/fr/datasets/donnees-hospitalieres-relatives-a-lepidemie-de-covid-19/) 
   -Données des urgences hospitalières et de SOS Médecins relatives à l'épidémie de COVID-19 (https://www.data.gouv.fr/fr/datasets/donnees-des-urgences-hospitalieres-et-de-sos-medecins-relatives-a-lepidemie-de-covid-19/)


En première partie :
Des requetes sql grâce à la bibliopthèque Sqlite3 permettant de réccuperer : 
-les Regions et départements  les plus touchées par nombre d'hospitalisation 
-Les classes d'age les plus touchées 
-Les jours de la semaine ayant le plus de cas covid19 confirmés
-la répartition par sexe des cas covid19

En deuxième partie : 
une visualisation graphiques des statistiques covid19 à l'aide des bibliothèque seaborn , matplotlib 

En troisième partie : 
Une visualisation des cluster covid  par Map interactif à l'aide de la bibliothèque folium 
