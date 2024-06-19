# Diagram as Code : générer ses schémas d’architecture avec C4 Model (Meetup Toulouse.rb)

Présentation réalisée lors du Meetup Toulouse.rb, dans les locaux de Sêmeia le 19/06/2024.

## Démarrer Structurizr

Une fois Docker démarré, créez un container en lui partageant le code via un volume :

```shell
docker run -it --rm -p 8080:8080 -v /path/to/the/cloned/github/repository:/usr/local/structurizr structurizr/lite
```

Puis, visitez `localhost:8080`.

## Rendus exportés

### Couche 1 : Système
![SystemContext layer](exports/structurizr-1-SystemContext.png "System Context")

### Couche 2 : Containers
![Containers layer](exports/structurizr-1-Containers.png "Containers")

### Couche 3 : Components
![Components layer](exports/structurizr-1-Components "Components")

### Diagramme d'Infrastructure : Single VM
![Infrastructure view: single VM](exports/structurizr-1-Deployment-001%20(4).png "Single VM")

### Diagramme d'Infrastructure : Hybrid Public Cloud
![Infrastructure view: Hybrid Public Cloud](exports/structurizr-1-Deployment-002.png "Hybrid Public Cloud")