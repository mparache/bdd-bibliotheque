/*******************************************************************************/

--                        Création des tables

/*******************************************************************************/


DROP TABLE IF EXISTS Joue CASCADE;
DROP TABLE IF EXISTS Realisation CASCADE;
DROP TABLE IF EXISTS Sanction CASCADE;
DROP TABLE IF EXISTS Pret CASCADE;
DROP TABLE IF EXISTS Exemplaire CASCADE;
DROP TABLE IF EXISTS EnregistrementMusical CASCADE;
DROP TABLE IF EXISTS Film CASCADE;
DROP TABLE IF EXISTS Livre CASCADE;
DROP TABLE IF EXISTS Adhesion CASCADE;
DROP TABLE IF EXISTS Contributeur CASCADE;
DROP TABLE IF EXISTS Adherent CASCADE;
DROP TABLE IF EXISTS Langue CASCADE;
DROP TABLE IF EXISTS MembrePersonnel CASCADE;

CREATE TABLE  Adherent  (
  numCarte NUMERIC PRIMARY KEY,
  telephone NUMERIC UNIQUE,
  dateNaiss DATE,
  loginPret VARCHAR(10) UNIQUE NOT NULL,
  mdpPret VARCHAR NOT NULL,
  blacklist BOOLEAN NOT NULL,
  nom VARCHAR(30) NOT NULL,
  prenom VARCHAR(30) NOT NULL,
  adresse VARCHAR(30),
  mail VARCHAR(30) NOT NULL
);
-- plusieurs adhérents de la même famille ont la même adresse mail

CREATE TABLE MembrePersonnel (
  loginAdm VARCHAR(10) PRIMARY KEY,
  mdpAdm VARCHAR NOT NULL,
  nom VARCHAR(30) NOT NULL,
  prenom VARCHAR(30) NOT NULL,
  adresse VARCHAR(30),
  mail VARCHAR(30) NOT NULL
);
-- plusieurs membres du personnel pourrait avoir la même adresse mail

CREATE TABLE Adhesion (
  id NUMERIC PRIMARY KEY ,
  dateDebut DATE NOT NULL,
  dateFin DATE NOT NULL,
  adherent NUMERIC NOT NULL,
  FOREIGN KEY (adherent) REFERENCES Adherent(numCarte)
);


CREATE TABLE Contributeur(
  id NUMERIC PRIMARY KEY,
  nom VARCHAR NOT NULL,
  prenom VARCHAR NOT NULL,
  dateNaiss DATE,
  Nationalite VARCHAR NOT NULL
);

CREATE TABLE Langue(
  nom VARCHAR PRIMARY KEY
);


CREATE TABLE Livre(
  code NUMERIC PRIMARY KEY,
  titre VARCHAR NOT NULL,
  dateApparition DATE,
  editeur VARCHAR ,
  genre VARCHAR NOT NULL,
  codeClassification VARCHAR NOT NULL,
  longueur NUMERIC,
  langue VARCHAR NOT NULL,
  auteur NUMERIC NOT NULL,
  editeurLivre NUMERIC NOT NULL,
  FOREIGN KEY (editeurLivre) REFERENCES Contributeur(id),
  FOREIGN KEY (auteur) REFERENCES Contributeur(id),
  FOREIGN KEY (langue) REFERENCES Langue(nom)
);

-- LE code dy livre est le code ISBN

CREATE TABLE EnregistrementMusical(
  code NUMERIC PRIMARY KEY,
  titre VARCHAR NOT NULL,
  dateApparition DATE,
  editeur VARCHAR,
  genre VARCHAR NOT NULL,
  codeClassification VARCHAR NOT NULL,
  longueur NUMERIC,
  compositeur NUMERIC NOT NULL,
  interprete NUMERIC NOT NULL,
  FOREIGN KEY (compositeur) REFERENCES Contributeur(id),
  FOREIGN KEY (interprete) REFERENCES Contributeur(id)
);

CREATE TABLE Film(
  code NUMERIC PRIMARY KEY,
  titre VARCHAR NOT NULL,
  dateApparition DATE,
  editeur VARCHAR,
  genre VARCHAR NOT NULL,
  codeClassification VARCHAR NOT NULL,
  longueur NUMERIC,
  synopsis VARCHAR,
  realisateur NUMERIC NOT NULL,
  FOREIGN KEY (realisateur) REFERENCES Contributeur(id)
);

CREATE TABLE Exemplaire(
  id NUMERIC UNIQUE NOT NULL PRIMARY KEY,
  etat VARCHAR NOT NULL CHECK (etat IN ('neuf','bon','abime')),
  disponibilite VARCHAR NOT NULL CHECK (disponibilite IN ('pret','disponible','perdu')),
  codeLivre NUMERIC,
  codeFilm NUMERIC,
  codeEnregistrement NUMERIC ,
  FOREIGN KEY (codeLivre) REFERENCES Livre(code),
  FOREIGN KEY (codeFilm) REFERENCES Film(code),
  FOREIGN KEY (codeEnregistrement) REFERENCES EnregistrementMusical(code),
  CHECK ((Exemplaire.codeLivre IS NOT NULL AND Exemplaire.codeFilm IS NULL AND Exemplaire.codeEnregistrement IS NULL)
  OR
  (Exemplaire.codeLivre IS NULL AND Exemplaire.codeFilm IS NOT NULL AND Exemplaire.codeEnregistrement IS NULL)
  OR
  (Exemplaire.codeLivre IS NULL AND Exemplaire.codeFilm IS NULL AND Exemplaire.codeEnregistrement IS NOT NULL))
);
-- Le CHECK sert à vérifier qu'un exemplaire est forcément lié à une ressource
CREATE TABLE Realisation(
  codeFilm NUMERIC NOT NULL,
  langue VARCHAR NOT NULL,
  FOREIGN KEY (langue) REFERENCES Langue(nom),
  FOREIGN KEY (codeFilm) REFERENCES Film(code),
  PRIMARY KEY (codeFilm,langue)
);

CREATE TABLE Pret (
  id NUMERIC PRIMARY KEY,
  dateDebut DATE NOT NULL,
  duree NUMERIC NOT NULL,
  rendu BOOLEAN NOT NULL DEFAULT FALSE,
  exemplaire NUMERIC NOT NULL,
  adherent NUMERIC NOT NULL,
  FOREIGN KEY (exemplaire) REFERENCES Exemplaire(id),
  FOREIGN KEY (adherent) REFERENCES Adherent(numCarte)
);

CREATE TABLE Joue(
  acteur NUMERIC NOT NULL,
  codeFilm NUMERIC NOT NULL,
  FOREIGN KEY (codeFilm) REFERENCES Film(code),
  FOREIGN KEY (acteur) REFERENCES Contributeur(id),
  PRIMARY KEY (codeFilm,acteur)
);

CREATE TABLE Sanction(
  id NUMERIC PRIMARY KEY ,
  description VARCHAR,
  type VARCHAR NOT NULL CHECK (type IN ('Retard','Deterioration','Perte')),
  datefinsanction DATE,
  remboursement BOOLEAN,
  membre VARCHAR(10) NOT NULL,
  adherent NUMERIC NOT NULL,
  pret NUMERIC NOT NULL,
  FOREIGN KEY (adherent) REFERENCES Adherent(numCarte),
  FOREIGN KEY (membre) REFERENCES MembrePersonnel(loginAdm),
  FOREIGN KEY (pret) REFERENCES Pret(id),
  CHECK ((type = 'Retard' AND datefinsanction IS NOT NULL AND remboursement IS NULL) OR ((type ='Deterioration' OR type = 'Perte') AND datefinsanction IS NULL AND remboursement IS NOT NULL))
);

/*******************************************************************************/

--                       Ajout dans les tables

/*******************************************************************************/

INSERT INTO Adherent VALUES (1,'0123456789',to_date('19990520','YYYYMMDD'),'Micrapau','mdp1',FALSE,'Richard','Jean','28 rue Roger Couttolenc','Jean.Richard@mail.com');
INSERT INTO Adherent VALUES (2,'0987654321',TO_DATE('19710623','YYYYMMDD'),'MathKoal','mdp2',FALSE,'Koala','Mathieu','12 rue Roger Vivenel','Mathieu.Koala@mail.com');
INSERT INTO Adherent VALUES (3,'0425653869',TO_DATE('19580914','YYYYMMDD'),'BenoLuca','mdp3',FALSE,'Benoit','Lucas','15 rue de Paris','Benoit.Lucas@mail.com');
INSERT INTO Adherent VALUES (4,'0523232323',TO_DATE('19580914','YYYYMMDD'),'Duboisju','mdp4',FALSE,'Dubois','Jules','1 rue des Sablons','Dubois.Jules@mail.com');
INSERT INTO Adherent VALUES (5,'0171568926',TO_DATE('20110214','YYYYMMDD'),'FranPatr','mdp5',FALSE,'Francis','Patrick','126 rue Winston Churchill','Francis.Patrick@mail.com');

INSERT INTO MembrePersonnel VALUES ('PassePar','mdp1','Partout','Passe','1 Rue du Port à bateaux','Partout.Passe@mail.com');
INSERT INTO MembrePersonnel VALUES ('PereFour','mdp2','Fourras','Pere','2 Rue du Port à bateaux','Fourras.Pere@mail.com');
INSERT INTO MembrePersonnel VALUES ('MoniqueF','mdp3','Monique','Felindra','3 Rue du Port à bateaux','Monique.Felindra@mail.com');
INSERT INTO MembrePersonnel VALUES ('PasseMur','mdp4','Muraille','Passe','4 Rue du Port à bateaux','Muraille.Passe@mail.com');

INSERT INTO Adhesion VALUES (1,TO_DATE('20180101','YYYYMMDD'),TO_DATE('20190101','YYYYMMDD'),1);
INSERT INTO Adhesion VALUES (2,TO_DATE('20180101','YYYYMMDD'),TO_DATE('20190101','YYYYMMDD'),2);
INSERT INTO Adhesion VALUES (3,TO_DATE('20180101','YYYYMMDD'),TO_DATE('20190101','YYYYMMDD'),3);
INSERT INTO Adhesion VALUES (4,TO_DATE('20190101','YYYYMMDD'),TO_DATE('20200101','YYYYMMDD'),1);
INSERT INTO Adhesion VALUES (5,TO_DATE('20190101','YYYYMMDD'),TO_DATE('20200101','YYYYMMDD'),2);
INSERT INTO Adhesion VALUES (6,TO_DATE('20190101','YYYYMMDD'),TO_DATE('20200101','YYYYMMDD'),1);
INSERT INTO Adhesion VALUES (7,TO_DATE('20170101','YYYYMMDD'),TO_DATE('20180101','YYYYMMDD'),1);
INSERT INTO Adhesion VALUES (8,TO_DATE('20190101','YYYYMMDD'),TO_DATE('20200101','YYYYMMDD'),4);
INSERT INTO Adhesion VALUES (9,TO_DATE('20200101','YYYYMMDD'),TO_DATE('2021101','YYYYMMDD'),1);
INSERT INTO Adhesion VALUES (10,TO_DATE('20200101','YYYYMMDD'),TO_DATE('20210101','YYYYMMDD'),3);
INSERT INTO Adhesion VALUES (11,TO_DATE('20200101','YYYYMMDD'),TO_DATE('20210101','YYYYMMDD'),4);

INSERT INTO Contributeur VALUES (1,'Zola','Emile',TO_DATE('19020929','YYYYMMDD'),'Francais');
INSERT INTO Contributeur VALUES (2,'De Balzac','Honore',TO_DATE('17990101','YYYYMMDD'),'Francais');
INSERT INTO Contributeur VALUES (3,'DAnnunzio','Gabriele',TO_DATE('18630101','YYYYMMDD'),'Italien');
INSERT INTO Contributeur VALUES (4,'Hugo','Victor',TO_DATE('18700101','YYYYMMDD'),'Francais');
INSERT INTO Contributeur VALUES (5,'M','Black',TO_DATE('19841227','YYYYMMDD'),'Francais');
INSERT INTO Contributeur VALUES (6,'SpielBerg','Steven',TO_DATE('19900114','YYYYMMDD'),'Américain');
INSERT INTO Contributeur VALUES (7,'Cameron','James',TO_DATE('19880228','YYYYMMDD'),'Américain');
INSERT INTO Contributeur VALUES (8,'Goldblum','Jeff',TO_DATE('19521022','YYYYMMDD'),'Américain');
INSERT INTO Contributeur VALUES (9,'Dern','Laura',TO_DATE('19740212','YYYYMMDD'),'Américain');
INSERT INTO Contributeur VALUES (10,'Peck','Bob',TO_DATE('19751114','YYYYMMDD'),'Américain');
INSERT INTO Contributeur VALUES (11,'Richards','Ariana',TO_DATE('19650531','YYYYMMDD'),'Américain');
INSERT INTO Contributeur VALUES (12,'Larousse','Dictionnaire',TO_DATE('18000101','YYYYMMDD'),'Francais');

INSERT INTO Langue VALUES('Francais');
INSERT INTO Langue VALUES('Anglais');
INSERT INTO Langue VALUES('Italien');
INSERT INTO Langue VALUES('Espagnol');


INSERT INTO Livre(code,titre,dateApparition,genre,codeClassification,langue,auteur,editeurLivre) VALUES (2765410054,'Germinal',TO_DATE('18850101','YYYYMMDD'),'Roman','14226','Francais',1,12);
INSERT INTO Livre(code,titre,dateApparition,genre,codeClassification,langue,auteur,editeurLivre) VALUES (1839452716,'Lassomoir',TO_DATE('18760101','YYYYMMDD'),'Roman','14227','Francais',1,12);
INSERT INTO Livre(code,titre,dateApparition,genre,codeClassification,langue,auteur,editeurLivre) VALUES (2356265956,'Fortune des rougons',TO_DATE('18710101','YYYYMMDD'),'Roman','14227','Francais',1,12);

INSERT INTO ENREGISTREMENTMUSICAL(code,titre,genre,dateApparition,codeClassification,longueur,compositeur,interprete) VALUES (1,'Sur ma route','Rap',TO_DATE('20140324','YYYYMMDD'),'24226',192,5,5);
INSERT INTO ENREGISTREMENTMUSICAL(code,titre,genre,dateApparition,codeClassification,longueur,compositeur,interprete) VALUES (2,'Je suis chez moi','Rap',TO_DATE('20170814','YYYYMMDD'),'24227',216,5,5);

INSERT INTO Film(code,titre,dateApparition,genre,codeClassification,longueur,synopsis,realisateur) VALUES (10,'JurassicPark',TO_DATE('19930228','YYYYMMDD'),'Fantastique','34226',127,'Un film avec des dinosaures',6);
INSERT INTO Film(code,titre,dateApparition,genre,codeClassification,longueur,synopsis,realisateur) VALUES (20,'Laguerredesmondes',TO_DATE('20050228','YYYYMMDD'),'ScienceFiction','34227',118,'Un film avec des mondes',6);

INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES (1,'neuf','pret',2765410054);
INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES (2,'bon','disponible',2765410054);
INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES (3,'neuf','pret',1839452716);
INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES (4,'bon','pret',2765410054);
INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES (5,'neuf','pret',10);
INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES (6,'bon','pret',10);
INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES (7,'bon','pret',20);
INSERT INTO Exemplaire(id,etat,disponibilite,codeEnregistrement) VALUES (8,'bon','pret',1);
INSERT INTO Exemplaire(id,etat,disponibilite,codeEnregistrement) VALUES (9,'bon','pret',1);
INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES (10,'abime','disponible',2765410054);

INSERT INTO Realisation VALUES (10,'Anglais');
INSERT INTO Realisation VALUES (10,'Francais');
INSERT INTO Realisation VALUES (10,'Espagnol');
INSERT INTO Realisation VALUES (20,'Anglais');
INSERT INTO Realisation VALUES (20,'Francais');

INSERT INTO Joue VALUES (8,10);
INSERT INTO Joue VALUES (9,10);
INSERT INTO Joue VALUES (10,10);
INSERT INTO Joue VALUES (11,10);


INSERT INTO Pret VALUES (1,TO_DATE('20200401','YYYYMMDD'),2,FALSE,1,1);
INSERT INTO Pret VALUES (2,TO_DATE('20200401','YYYYMMDD'),2,FALSE,3,1);
INSERT INTO Pret VALUES (3,TO_DATE('20200401','YYYYMMDD'),25,FALSE,4,1);
INSERT INTO Pret VALUES (4,TO_DATE('20200401','YYYYMMDD'),25,FALSE,5,1);
INSERT INTO Pret VALUES (5,TO_DATE('20200401','YYYYMMDD'),25,FALSE,7,1);
INSERT INTO Pret VALUES (6,TO_DATE('20200401','YYYYMMDD'),25,TRUE,8,1);
INSERT INTO Pret VALUES (7,TO_DATE('20190101','YYYYMMDD'),25,TRUE,2,2);
INSERT INTO Pret VALUES (8,TO_DATE('20200401','YYYYMMDD'),25,FALSE,8,2);
INSERT INTO Pret VALUES (9,TO_DATE('20200320','YYYYMMDD'),25,FALSE,9,4);
INSERT INTO Pret VALUES (10,TO_DATE('20200320','YYYYMMDD'),25,FALSE,6,4);

INSERT INTO Sanction (id,description,type,datefinsanction,membre,adherent,pret) VALUES (1,'Hopela Un retard pour toi de la part de PassePartout','Retard',TO_DATE('20200405','YYYYMMDD'),'PassePar',1,1);
INSERT INTO Sanction (id,description,type,datefinsanction,membre,adherent,pret) VALUES (2,'"Hopela Un retard pour toi de la part de PassePartout"','Retard',TO_DATE('20200405','YYYYMMDD'),'PassePar',1,2);
INSERT INTO Sanction (id,description,type,remboursement,membre,adherent,pret) VALUES (3,'"Hopela Une deterioration pour toi de la part de PassePartout"','Deterioration','TRUE', 'PassePar',1,2);
/*******************************************************************************/

--            Vues liées contraintes liées aux héritages ou aux associations

/*******************************************************************************/
-- C1, C2 ET C3 sont trois vues qui doivent être vides
CREATE VIEW vLivreFilmMemeCode(codeLivre) AS
SELECT Livre.code FROM Livre, Film WHERE Livre.code = Film.code GROUP BY Livre.code;
CREATE VIEW vFilmEnregistrementMemeCode(codeFilm) AS
SELECT Film.code FROM EnregistrementMusical, Film WHERE EnregistrementMusical.code = Film.code GROUP BY Film.code;
CREATE VIEW vEnregistrementLivreMemeCode(codeEnregistrementMusical) AS
SELECT EnregistrementMusical.code FROM Livre, EnregistrementMusical WHERE EnregistrementMusical.code = Livre.code GROUP BY EnregistrementMusical.code ;



-- Vue pour vérifier qu'il y a au plus deux sanctions par prêt :
CREATE VIEW vnbSanctionsTropEleve(idPret,Nombre) AS
SELECT p.id,count(s.id) AS Nombre FROM Pret p LEFT JOIN Sanction s ON p.id = s.Pret GROUP BY p.id HAVING count(s.id) > 2;

--  Vue pour vérifier que les adhérents qui subissent des sanctions sont bien ceux qui le méritent dans Sanction -> pret . adherent  = Sanction -> Adherent
CREATE VIEW vadherentPbSanction(idAdherent)AS
SELECT Sanction.adherent FROM Pret,Sanction WHERE Sanction.pret = Pret.id AND Sanction.adherent <> Pret.adherent GROUP BY Sanction.adherent;




/*******************************************************************************/

--                        Réponse aux besoins donnés

/*******************************************************************************/
-- Question 1 : Faciliter aux adhérents la recherche des documents et la gestion de leur emprunt
/* Vue pour voir les emprunts d'un utilisateur donné (ici l'utisateur $adhe)
CREATE VIEW ListePret (id,titreL,titreE,titreF) AS
SELECT Exemplaire.id, Livre.titre, EnregistrementMusical.titre, Film.Titre FROM ((((Adherent LEFT JOIN Pret ON Adherent.numcarte=Pret.adherent)
LEFT JOIN Exemplaire ON Exemplaire.id=Pret.exemplaire)
LEFT JOIN Livre  ON Exemplaire.codeLivre = Livre.code)
LEFT JOIN Film  ON Exemplaire.codeFilm = Film.code)
LEFT JOIN EnregistrementMusical ON Exemplaire.codeEnregistrement = EnregistrementMusical.code
WHERE Pret.rendu=False AND Adherent.numCarte = $adhe
*/

--Vue pour que les adhérents puissent voir l'ensemble des exemplaires disponibles
CREATE VIEW vExemplaireDispo(code,ftitre,ltitre,etitre) AS
SELECT id, f.titre,l.titre,e.titre FROM ((Exemplaire LEFT JOIN Livre l ON Exemplaire.codeLivre = l.code) LEFT JOIN Film f ON Exemplaire.codeFilm = f.code) LEFT JOIN EnregistrementMusical e
ON Exemplaire.codeEnregistrement = e.code
WHERE disponibilite = 'disponible'
AND etat<>'abime'
GROUP BY id, f.titre,l.titre,e.titre ;

/* Vue pour que les adhérents trouvent les exemplaires disponibles à partir d'un titre qu'ils ont fournis
CREATE VIEW ChercherDocument (id,titreL,titreE,titreF) AS
SELECT Exemplaire.id, Livre.titre, EnregistrementMusical.titre, Film.Titre
FROM ((Exemplaire LEFT JOIN Livre  ON Exemplaire.codeLivre = Livre.code)
LEFT JOIN Film  ON Exemplaire.codeFilm = Film.code)
LEFT JOIN EnregistrementMusical ON Exemplaire.codeEnregistrement = EnregistrementMusical.code
WHERE EnregistrementMusical.titre=$titre OR Livre.Titre=$titre OR Film.Titre=$titre
AND Exemplaire.disponibilte='disponible'
AND Exemplaire.etat<>'abime';
*/

-- Question 2 : Faciliter la gestion des ressources, ajout et modification

-- Commande pour ajouter des films : Sachant que l'utilisateur aura rentré les valeurs précédées par des $, certains éléments pourront être NULL
--INSERT INTO Livre(code,titre,dateApparition,editeur,genre,codeClassification,langue,auteur,editeurLivre)
-- VALUES ($ISBN,$titre,TO_DATE($date,'YYYYMMDD'),$editeur,$genre,$classification,$langue,$auteur,$editeurLivre);
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES ($id,$etat,'disponible',$code);
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES ($id2,$etat2,'disponible',$code);
-- ...



-- Commande pour ajouter des films : Sachant que l'utilisateur aura rentré les valeurs précédées par des $, certains éléments pourront être NULL
-- INSERT INTO Film(code,titre,dateApparition,editeur, genre,codeClassification,longueur,synopsis,realisateur)
-- VALUES ($code,$titre,TO_DATE($date,'YYYYMMDD'),$editeur,$genre,$classification,$longueur,$synopsis,$realisateur);
-- INSERT INTO Realisation VALUES ($code,*langue1);
-- INSERT INTO Realisation VALUES ($code,*langue2);
-- ...
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES ($id,$etat,'disponible',$code);
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES ($id2,$etat2,'disponible',$code);
-- ...


-- Commande pour ajouter des films : Sachant que l'utilisateur aura rentré les valeurs précédées par des $, certains éléments pourront être NULL
--INSERT INTO EnregistrementMusical(code,titre,dateApparition,editeur,genre,codeClassification,longueur,compositeur,interprete)
-- VALUES ($code,$titre,TO_DATE($date,'YYYYMMDD'),$editeur,$genre,$classification,$longueur,$compositeur,$interprete);
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES ($id,$etat,'disponible',$code);
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES ($id2,$etat2,'disponible',$code);
-- ...

--Commande pour update le synopsis d'un film qui a déjà été recherché par le membre du personnel
--UPDATE Film SET synopsis =$update  WHERE code =$code;

-- Commande pour ajouter des exemplaires à une ressource que l'on récupère via son id et le type, que l'on aura récupéré via le titre puis une sélection du membre
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeFilm) VALUES ($id,$etat,'disponible',$code);
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeLivre) VALUES ($id,$etat,'disponible',$code);
-- INSERT INTO Exemplaire(id,etat,disponibilite,codeEnregistrement) VALUES ($id,$etat,'disponible',$code);

-- Question 3 : Faciliter au personnel la gestion des prêts, des retards mais aussi avoir la liste des adhérents qui peuvent emprunter
-- Vue pour afficher les retards
CREATE VIEW PretsEnRetard (NumCarteAdherant,NomAdherent,idExemplaire) AS
SELECT Adherent.numCarte,Adherent.nom,Pret.exemplaire FROM Adherent,Pret
WHERE Pret.rendu=FALSE
AND  Pret.DateDebut + Pret.duree * INTERVAL '1 day' <= current_date
AND Pret.adherent=adherent.NumCarte;

-- Vue pour vérifier que les adhérents peuvent emprunter
CREATE VIEW vNb_Pret (numCarte, nb) AS
SELECT Adherent.numCarte, COUNT(*) AS Nb_Pret FROM Adherent, Pret
WHERE Adherent.numCarte=Pret.adherent
AND Pret.rendu=false
GROUP BY Adherent.numCarte;

CREATE VIEW vadhe_ok (numcarte,nom,prenom) AS
SELECT a.numcarte,a.nom,a.prenom FROM  (((adherent a LEFT JOIN sanction s ON a.numCarte=s.adherent)
LEFT JOIN pret p ON a.numCarte=p.adherent) JOIN adhesion ad ON a.numCarte=ad.adherent)LEFT JOIN  vNb_pret n ON  a.numCarte=n.numCarte
WHERE a.blacklist=false
AND (s.remboursement IS NULL OR s.remboursement=true )
AND (s.datefinsanction IS NULL OR s.datefinsanction<current_date)
AND ad.datefin>current_date
AND (n.nb IS NULL OR n.nb<5)
GROUP BY a.numcarte,a.nom,a.prenom;


-- Question 4 : Facilitation la gestion des utilisateurs et de leurs données
--Creation des USERS
/*
CREATE USER UnAdherent;
CREATE USER UnMembrePersonnel;

GRANT SELECT ON Livre,Film,EnregistrementMusical,vExemplaire TO UnAdherent;

GRANT ALL PRIVILEGES ON Livre TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Film TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON EnregistrementMusical TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Contributeur TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Langue TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Exemplaire TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Pret TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Sanction TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Joue TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Adhesion TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Adherent TO UnMembrePersonnel;
GRANT ALL PRIVILEGES ON Realisation TO UnMembrePersonnel;

GRANT SELECT ON vnbEmpruntsEnregistrement TO UnMembrePersonnel;
GRANT SELECT ON vnbEmpruntsFilm TO UnMembrePersonnel;
GRANT SELECT ON vnbEmpruntsLivre TO UnMembrePersonnel;
GRANT SELECT ON vLivreFilmMemeCode TO UnMembrePersonnel;
GRANT SELECT ON vFilmEnregistrementMemeCode TO UnMembrePersonnel;
GRANT SELECT ON vadherentPbSanction TO UnMembrePersonnel;
GRANT SELECT ON nbSanctionsTropEleve TO UnMembrePersonnel;
GRANT SELECT ON vEnregistrementLivreMemeCode TO UnMembrePersonnel;
GRANT SELECT ON vadhe_ok TO UnMembrePersonnel;


Récupération de tous les adhérents
SELECT * FROM Adherent;
Récupération de tous les membres du personnel
SELECT * FROM MembrePersonnel;


-- Ajout d'un Adherent blacklisté par le numéro de sa carte
--UPDATE Adherent SET blacklist = True  WHERE numCarte =$numCarte;

-- Ajout d'un UPDATE pour changer de mail mais adaptable à téléphone, adresse à partir du numéro de la carte
--UPDATE Adherent SET mail = $mail  WHERE numCarte =$numCarte;
*/

-- Question 5 : Statistiques sur ressources avec % d'emprunts d'une ressource / emprunts de toutes les ressources

CREATE VIEW vnbEmprunts(nombre)AS
SELECT Count(*) FROM Pret;
-- Ces 3 vues servent à compter le nombre d'emptunts d'une ressource
CREATE VIEW vnbEmpruntsLivre(code,titre,NbEmpruntsDelivre,pourcentagetotal) AS
SELECT codeLivre,titre, COUNT(*) AS NbEmpruntsDelivre,(COUNT(*)*100/nombre) AS pourcentagetotal FROM Exemplaire,Pret,Livre,vnbEmprunts
WHERE Exemplaire.codeLivre IS NOT NULL
AND Exemplaire.id=Pret.exemplaire
AND Exemplaire.codeLivre = Livre.code
GROUP BY codeLivre,titre,nombre;

CREATE VIEW vnbEmpruntsFilm(code,titre,NbEmpruntsDeFilm,pourcentagetotal) AS
SELECT codeFilm, titre,COUNT(*) AS NbEmpruntsDeFilm ,(COUNT(*)*100/nombre) AS pourcentagetotal FROM Exemplaire,Pret,Film,vnbEmprunts
WHERE Exemplaire.codeFilm IS NOT NULL
AND Exemplaire.id=Pret.exemplaire
AND Exemplaire.codeFilm = Film.code
GROUP BY codeFilm,titre,nombre;

CREATE VIEW vnbEmpruntsEnregistrement(code,titre,NbEmpruntsDEnregistrement,pourcentagetotal) AS
SELECT codeEnregistrement,titre, COUNT(*) AS NbEmpruntsDEnregistrement,(COUNT(*)*100/nombre) AS pourcentagetotal FROM Exemplaire,Pret,EnregistrementMusical,vnbEmprunts
WHERE Exemplaire.codeEnregistrement IS NOT NULL
AND Exemplaire.id=Pret.exemplaire
AND Exemplaire.codeEnregistrement = EnregistrementMusical.code
GROUP BY codeEnregistrement,titre,nombre;

-- Vue qui donne le nombre de prêt par genre par type de ressources, ainsi on peut voir quel genre et type de ressources il préfère
CREATE VIEW StatistiquesAdherent (id) AS
SELECT Adherent.numcarte,livre.genre AS lgenre,film.genre AS fgenre,EnregistrementMusical.genre AS Egenre,COUNT(livre.code) AS cptLivre,COUNT(Film.code)AS cptFilm,COUNT(EnregistrementMusical.code)AS cptEnr
FROM ((((Adherent LEFT JOIN Pret ON Adherent.numcarte=Pret.adherent)
LEFT JOIN Exemplaire ON Exemplaire.id=Pret.exemplaire)
LEFT JOIN Livre  ON Exemplaire.codeLivre = Livre.code)
LEFT JOIN Film  ON Exemplaire.codeFilm = Film.code)
LEFT JOIN EnregistrementMusical ON Exemplaire.codeEnregistrement = EnregistrementMusical.code
GROUP BY Adherent.numcarte,livre.genre,film.genre,EnregistrementMusical.genre
ORDER BY Adherent.numcarte;
