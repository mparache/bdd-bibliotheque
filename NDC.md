# Note De Clarification

## Liste des objets présents dans la base et leur propriétés
Dans la base de données, il y a des ressources qui peuvent être des livres, des films ou bien des enregistrements musicaux :
* Une ressource a un code, un titre, une date d'apparition, un genre et un code de classification
* Les livres ont un code isbn unique et un résumé
* Les films ont une longueur et un synopsis
* Les enregistrements musicaux ont une certaine longueur

On trouvera aussi les différentes langues des ressources :
*  Ces  langues ont un nom

Les contributeurs sont liés aux différentes ressources citées auparavant
* les contributeurs ont un nom, un prénom, une date de naissance et une nationalité

La base de données est utilisée par des utilisateurs qui peuvent être des adhérents ou des membres du personnel de la bibliothèque :
* Les utilisateurs ont un nom, un prénom, une adresse et un mail
* Les adhérents ont un numéro de carte d'adhérent, un numéro de téléphone, une date de naissance, un login, un mot de passe et peuvent être blacklistés
* Les membres du personnel ont un login et un mot de passe

Les adhésions actuelles et passées des adhérents sont recensées :
* Elles ont une date de début et une date de fin

Dans la base de données, on trouvera aussi les différents exemplaires de chaque ressource appartenant à la bibliothèque :
* Un exemplaire a un état {neuf, bon, abîmé}, une disponibilité {disponible, prêté, perdu} et un identifiant

Les sanctions des adhérents sont recensées, elles peuvent être liées à des retards, des déteriorations et/ou des pertes :
* Les sanctions ont un identifiant et une description
* Les retards sont sanctionnés par une date jusqu'à laquelle l'adhérent ne peut pas faire de prêt
* Les pertes et les déteriorations ont un booléen spécifiant si l'exemplaire a été remboursé ou non

Dans la base de données, on trouve les différents prêts faits par les adhérents :
* Les prêts ont une date, une durée et peuvent être terminés/rendus. On peut déterminer si l'emprunteur a dépassé le délai pour rendre l'exemplaire

## Liste des contraintes associées à ces objets et propriétés
Les ressources peuvent exister en plusieurs exemplaires mais un exemplaire ne peut être lié qu'à une seule ressource. <br>
Un livre est écrit en une seule langue mais une langue peut être associée à plusieurs livres.<br>
Un film peut être réalisé en plusieurs langues et une langue peut être associé à plusieurs films.<br>
Un contributeur peut réaliser plusieurs films mais un film ne pourra être réalisé que par un réalisateur.<br>
Un contributeur peut être acteur dans plusieurs films et un film peut avoir plusieurs acteurs.<br>
Un contributeur peut être l'auteur et/ou l'éditeur de plusieurs livres et un livre peut avoir au plus un auteur et un éditeur. <br>
Un contributeur peut composé et/ou interprété un enregistrement musical et un enregistrement musical peut être composé et interprété par un seul contributeur.<br>
Un exemplaire peut être associé à plusieurs prêts mais un prêt n'est associé qu'à un seul exemplaire.<br>
Un adhérent peut faire au plus 5 prêts à la fois et un prêt n'est lié qu'à un seul utilisateur.<br>
Un adhérent peut souscrire à plusieurs adhésions au cours de sa vie mais une adhésion n'est lié quà un seul adhérent.<br>
Un adhérent peut subir plusieurs sanctions mais une sanction ne peut être subie que par un adhérent (chaque cause est différente).<br>
Un membre du personnel peut donner plusieurs sanctions mais une sanction n'est donnée que par un membre.<br>
Un prêt peut être lié à aucune, une ou deux sanctions et une sanction n'est liée qu'à un seul prêt.<br>

## Liste des utilisateurs qui vont utiliser la base de données, leur rôle et leurs droits
- Les adhérents à la bibliothèque ont le droit de consulter les exemplaires existants et d'emprunter des livres à condition que l'adhésion soit à jour et qu'il soit authentifié. 
- Les membres du personnel peuvent consulter mais aussi modifier et ajouter du contenu, ils peuvent aussi gérer les retours des documents. Ils peuvent sanctionner les adhérents et même les blacklister. Ils auront pour cela accès à des vues pour voir les prêts en retard.
Ils auront aussi accès à des vues pour les statistiques tels que le nombre d'emprunts par catégorie de ressources. Ils auront une liste d'adhérent qui pourront emprunter (ceux qui remplissent toutes les conditions).
Pour vérifier la gestion des données au niveau des ressources, les membres du personnel auront accès à des vues qui montreront la non-cohérence des données notamment au niveau des héritages. 

## Hypothèses faites sur le sujet
On émet les hypothèses suivantes: <br>
* Un livre n'est écrit qu'en une seule langue , les langues ont un nom unique. 
* Chaque exemplaire d'une ressource a un identifiant pour distinguer les exemplaires d'une même ressource.
* Chaque exemplaire est nécessairement liée à une ressource. Un exemplaire n'existe pas sans ressource.
* Il y a au plus un auteur par livre et au plus un interprète par enregistrements musicaux.
* Les login et mdp des adhérents et des membres du personnel sont différents et permettent d'accéder à deux interfaces différentes.
* Un adhérent ne pourra souscrire qu'à une nouvelle adhésion que si la sienne en'est plus valide.
* Un adhérent pourra faire plus de 5 emprunts dans sa vie à condition qu'il rend   les exemplaires empruntés et qu'il en ait 5 au maximum au même moment.
* Un adhérent pourra faire un emprunt uniquement si son adhésion est à jour, s'il est authentifié et s'il n'est pas blacklisté.
* La gestion des ajouts est donné aux membres du personnel qui devront vérifier si leurs ajouts sont cohérents via des vues.
