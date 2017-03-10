// Laetitia Monnier

program automobile;

uses crt, dateutils;

CONST
	MAXVOITURE = 15;
	MAXGARAGE = 2;
	ANNEEACTUEL = 2017;
	MOISACTUEL = 3;
	JOURACTUEL = 9;

TYPE
	calendrier = record
		Jour : integer;
		Mois : integer;
		Annee : integer;
end;

TYPE
	voiture = record
		marque : string;
		modele : string;
		energie : string;
		puissanceFiscale : string;
		puissanceDYN : string;
		couleur :string;
		options : string;
		anneeModele : calendrier;
		prixModele : integer;
		dateMiseCirculation : calendrier;
end;

TYPE
	garage = record
		nom : string;
		adresse : string;
		CP : string;
		ville : string;
		telephone : string;
		email : string;
		nombreVoitures : integer;
		tableauVoiture : array[1..MAXVOITURE] of voiture;
end;

TYPE	
	tableauGarage = array[1..MAXGARAGE] of garage;

PROCEDURE effaceEcran(); // Cette procedure permet de nettoyer l'écran.
begin
	clrscr;
	writeln('Programme : Garage Automobile.');
	writeln;
end;

FUNCTION generationImmatriculation():string;
VAR
	immatriculation, chiffre : string;
	i, x : integer;
begin
	immatriculation := '';
	FOR i := 1 TO 5 DO // Je fais une première boucle pour générer les numéros de la plaque...
	begin
		x := random(26) + 65;
		immatriculation := immatriculation + chr(ord(x));
		IF (i = 3) OR (i = 5) THEN immatriculation := immatriculation + '-';
	end;
	FOR i := 1 TO 2 DO //... et une deuxième pour les lettres.
	begin
		str(random(10), chiffre);
		immatriculation := immatriculation + chiffre;
	end;
	generationImmatriculation := immatriculation;
end;

PROCEDURE affichageMoyenneGarage(tG : tableauGarage);
VAR
	i, j, moyenne, moyenneGenerale : integer;
begin
	moyenneGenerale := 0;
	FOR i := 1 TO MAXGARAGE DO
	begin
		moyenne := 0;
		FOR j := 1 TO tG[i].nombreVoitures DO
		begin
			moyenne := moyenne + tG[i].tableauVoiture[j].prixModele;
		end;
		moyenne := moyenne DIV tG[i].nombreVoitures;
		moyenneGenerale := moyenneGenerale + moyenne; 
		writeln('Voici la moyenne des valeurs des véhicules pour le garage ', i, ' : ', moyenne);
	end;
	moyenneGenerale := moyenneGenerale DIV MAXGARAGE;
	writeln('Voici la moyenne des valeurs des véhicules de tous les garages : ', moyenneGenerale);
	readln;
end;

PROCEDURE affichageVoiture(v : voiture);
VAR
	age : integer;
	argus : real;
begin
	writeln;
	age := ANNEEACTUEL - v.anneeModele.Annee;
	argus := v.prixModele;
	writeln('Marque : ', v.marque);
	writeln('Modèle : ',v.modele);
	writeln('Energie : ',v.energie);
	writeln('Puissance Fiscale : ',v.puissanceFiscale);
	writeln('Puissance DYN : ',v.puissanceDYN);
	writeln('Couleur : ',v.couleur);
	writeln('Options : ',v.options);
	writeln('Année du modèle : ',v.anneeModele.Annee);
	writeln('Prix du modèle : ',v.prixModele,' €');
	IF age < 4 THEN // Cette partie du programme calcul la cote argus.
	begin
		IF age > 0 THEN argus := argus * 0.75;
		IF age > 1 THEN argus := argus * 0.9;
		IF age > 2 THEN argus := argus * 0.9;
	end
	ELSE argus := 0;
	writeln('Cote Argus : ', trunc(argus), '€');
	writeln('Date de mise en circulation : ',v.dateMiseCirculation.Annee,'/',v.dateMiseCirculation.Mois,'/',v.dateMiseCirculation.Jour);
	writeln('Age : ',age,' ans');
	writeln('Plaque d''immatriculation : ', generationImmatriculation());
	writeln;
end;

PROCEDURE affichageVoitureChere(tG : tableauGarage); // Cette procedure affiche la voiture la plus chère à neuf, parmi toutes les voitures inscrites.
VAR
	i, j, prixVoiture : integer;
	v : voiture;
begin
	FOR i := 1 TO MAXGARAGE DO
	begin
		FOR j := 1 TO tG[i].nombreVoitures DO
		begin
			IF tG[i].tableauVoiture[j].prixModele > prixVoiture THEN
			begin
				prixVoiture := tG[i].tableauVoiture[j].prixModele;
				v := tG[i].tableauVoiture[j];
			end;
		end;
	end;
	writeln('La voiture la plus chère est : ');
	affichageVoiture(v);
	readln;
end;

PROCEDURE affichageVoitureAncienne(tG : tableauGarage); // Cette procedure affiche la voiture la plus ancienne, parmi toutes les voitures inscrites.
VAR
	i, j : integer;
	dateAncienne : calendrier;
	v : voiture;
begin
	dateAncienne.Annee := ANNEEACTUEL;
	dateAncienne.Mois := MOISACTUEL;
	dateAncienne.Jour := JOURACTUEL;
	FOR i := 1 TO MAXGARAGE DO
	begin
		FOR j := 1 TO tG[i].nombreVoitures DO
		begin
			IF tG[i].tableauVoiture[j].dateMiseCirculation.Annee < dateAncienne.Annee THEN // On compare l'année...
			begin
				dateAncienne.Annee := tG[i].tableauVoiture[j].dateMiseCirculation.Annee;
				dateAncienne.Mois := tG[i].tableauVoiture[j].dateMiseCirculation.Mois;
				dateAncienne.Jour := tG[i].tableauVoiture[j].dateMiseCirculation.Jour;
				v := tG[i].tableauVoiture[j];
			end
			ELSE IF tG[i].tableauVoiture[j].dateMiseCirculation.Annee = dateAncienne.Annee THEN // ... si deux voitures ont la même année...
			begin
				IF tG[i].tableauVoiture[j].dateMiseCirculation.Mois < dateAncienne.Mois THEN // ... on compare le mois...
				begin
					dateAncienne.Mois := tG[i].tableauVoiture[j].dateMiseCirculation.Mois;
					dateAncienne.Jour := tG[i].tableauVoiture[j].dateMiseCirculation.Jour;
					v := tG[i].tableauVoiture[j];
				end
				ELSE IF tG[i].tableauVoiture[j].dateMiseCirculation.Mois = dateAncienne.Mois THEN // ... si deux voitures ont le même mois...
				begin
					IF tG[i].tableauVoiture[j].dateMiseCirculation.Jour < dateAncienne.Jour THEN // ... on compare le jour.
					begin
						dateAncienne.Jour := tG[i].tableauVoiture[j].dateMiseCirculation.Jour;
						v := tG[i].tableauVoiture[j];
					end;
				end;
			end;
		end;
	end;
	writeln('La voiture la plus ancienne est : ');
	affichageVoiture(v);
	readln;
end;

PROCEDURE affichageGaragePlusDeVoiture(tG : tableauGarage);
begin
	IF tG[1].nombreVoitures > tG[2].nombreVoitures THEN
		writeln('Le garage 1 possède le plus de voiture.')
	ELSE
		writeln('Le garage 2 possède le plus de voiture.');
	readln;
end;

PROCEDURE affichageGarage(tG : tableauGarage); // On affiche un garage et ses voitures.
VAR
	choixG : integer;
	i : integer;
begin
	clrscr;
	writeln;
	writeln('Quel garage souhaitez-vous afficher ?');
	writeln('1 : Garage 1');
	writeln('2 : Garage 2');
	readln(choixG);
	writeln;
	writeln('Nom du garage : ', UPCASE(tG[choixG].nom));
	writeln('Adresse : ', tG[choixG].adresse);
	writeln('Code postal : ',tG[choixG].CP);
	writeln('La ville : ',UPCASE(tG[choixG].ville));
	writeln('Le numéro de téléphone : ',tG[choixG].telephone);
	writeln('L''email : ',tG[choixG].email);
	FOR i := 1 TO (tG[choixG].nombreVoitures) DO affichageVoiture(tG[choixG].tableauVoiture[i]);
	readln();
end;

FUNCTION verifNbVoiture(nombreVoitures : integer):boolean; // Sert à vérifier que le nombre de voiture n'excède pas le max (qui est de 15 voitures dans un garage).
VAR
	resultat : boolean;
begin
	resultat := TRUE;
	IF nombreVoitures >= MAXVOITURE THEN
		resultat := FALSE;
	verifNbVoiture := resultat;
end;

PROCEDURE ajoutVoitureDansGarage(var tG : tableauGarage; v : voiture); // Donc si un garage est rempli, on boucle de sorte à ce que l'utilisateur prenne l'autre garage. Si les deux sont remplis, on peut annuler l'inscription.
VAR
	choixG : integer;
	verif : boolean;
begin
	REPEAT
		writeln;
		writeln('Dans quel garage souhaitez-vous mettre votre voiture ?');
		writeln('1 : Garage 1');
		writeln('2 : Garage 2');
		writeln('0 : Annuler l''inscription');
		readln(choixG);
		IF choixG > 0 THEN
		begin
			verif := verifNbVoiture(tG[choixG].nombreVoitures);
			IF verif = TRUE THEN
			begin
				tG[choixG].nombreVoitures := tG[choixG].nombreVoitures + 1;
				tG[choixG].tableauVoiture[tG[choixG].nombreVoitures] := v;
				writeln('Votre voiture a bien été inscrite dans le garage ', choixG, '.');
			end
			ELSE writeln('Il n''y a plus de place dans ce garage.');
			readln();
		end;
	UNTIL (choixG = 0) OR (verif = TRUE);
end;

PROCEDURE renseignementVoiture(var tG : tableauGarage);
VAR
	v : voiture;
begin
	writeln;
	writeln('Entrez la marque de la voiture :');
	readln(v.marque);
	writeln('Entrez le modèle de la voiture :');
	readln(v.modele);
	writeln('Entrez l''energie utilisé par la voiture :');
	readln(v.energie);
	writeln('Indiquez la puissance fiscale de la voiture :');
	readln(v.puissanceFiscale);
	writeln('Indiquez la puissance DYN de la voiture :');
	readln(v.puissanceDYN);
	writeln('Indiquez la couleur de la voiture :');
	readln(v.couleur);
	writeln('Entrez les options de la voiture, séparé par un ''#'' :');
	readln(v.options);
	writeln('Indiquez l''année du modèle de la voiture :');
	readln(v.anneeModele.Annee);
	writeln('Indiquez le prix du modèle (valeur à neuf) :');
	readln(v.prixModele);
	REPEAT
		writeln('Entrez la date de mise en circulation de la voiture (Annee/Mois/Jour) :');
		readln(v.dateMiseCirculation.Annee);
		readln(v.dateMiseCirculation.Mois);
		readln(v.dateMiseCirculation.Jour);
	UNTIL IsValidDate(v.dateMiseCirculation.Annee, v.dateMiseCirculation.Mois, v.dateMiseCirculation.Jour) = TRUE; // Valide que la date soit bonne.
	ajoutVoitureDansGarage(tG, v);
end;

FUNCTION verifMail(email : string):boolean; // Verifie que l'utilisateur ait entré une adresse mail.
VAR
	compteur : integer;
	resultat : boolean;
	arobase : boolean;
begin
	resultat := FALSE;
	arobase := FALSE;
	FOR compteur := 1 TO length(email) DO
	begin
		IF email[compteur] = '@' THEN arobase := TRUE;
		IF (email[compteur] = '.') AND (arobase = TRUE) THEN resultat := TRUE;
	end;
	verifMail := resultat;
end;

FUNCTION verifTelephone(tel : string):boolean;
VAR
	compteur : integer;
	resultat : boolean;
begin
	resultat := FALSE;
	IF length(tel) = 10 THEN
	begin
		FOR compteur := 1 TO length(tel) DO
		begin
			IF (tel[compteur] = '0') OR (tel[compteur] = '1') OR (tel[compteur] = '2') OR (tel[compteur] = '3') OR (tel[compteur] = '4') OR (tel[compteur] = '5') OR
			(tel[compteur] = '6') OR (tel[compteur] = '7') OR (tel[compteur] = '8') OR (tel[compteur] = '9') THEN resultat := TRUE;
		end;
	end;
	verifTelephone := resultat;
end;

PROCEDURE renseignementGarage(var tG : tableauGarage);
var
	g : garage;
	choixG : integer;
begin
	writeln;
	writeln('Quel garage souhaitez-vous renseigner ?');
	writeln('1 : Garage 1');
	writeln('2 : Garage 2');
	readln(choixG);
	writeln;
	writeln('Entrez le nom du garage :');
	readln(tG[choixG].nom);
	writeln('Entrez l''adresse du garage :');
	readln(tG[choixG].adresse);
	writeln('Entrez le code postal du garage :');
	readln(tG[choixG].CP);
	writeln('Indiquez la ville du garage :');
	readln(tG[choixG].ville);
	REPEAT
		writeln('Indiquez le numéro de téléphone du garage :');
		readln(tG[choixG].telephone);
		verifTelephone(tG[choixG].telephone);
	UNTIL verifTelephone(tG[choixG].telephone) = TRUE;
	REPEAT
		writeln('Indiquez l''email du garage :');
		readln(tG[choixG].email);
		verifMail(tG[choixG].email);
	UNTIL verifMail(tG[choixG].email) = TRUE;
end;


FUNCTION menuAffichage(tG : tableauGarage):integer; // Sous menu du menu principal.
VAR
	choixA : integer;
begin
	writeln;
	writeln('Veuillez faire votre choix :');
	writeln('1 : Afficher un garage et ses voitures');
	writeln('2 : Afficher le garage qui a le plus de voiture');
	writeln('3 : Afficher le véhicule le plus ancien');
	writeln('4 : Afficher la moyenne des valeurs des véhicules');
	writeln('5 : Afficher le véhicule le plus cher en valeur à neuf');
	writeln('6 : Afficher le véhicule le plus cher en cote argus à 3 ans');
	readln(choixA);
	CASE choixA OF
		1 : affichageGarage(tG);
		2 : affichageGaragePlusDeVoiture(tG);
		3 : affichageVoitureAncienne(tG);
		4 : affichageMoyenneGarage(tG);
		5 : affichageVoitureChere(tG);
	end;
	effaceEcran();
	menuAffichage := choixA;
end;

FUNCTION menuPrincipal(var tG : tableauGarage):integer;
VAR
	choix, prixVoiture :integer;
begin
	prixVoiture := 0; // J'initialise le prix ici, afin que cela ne se fasse qu'une fois. 
	writeln('Veuillez faire votre choix :');
	writeln('1 : Renseigner un garage');
	writeln('2 : Renseigner une voiture');
	writeln('3 : Afficher les garages et les voitures');
	writeln('0 : Sortir du programme');
	readln(choix);
	CASE choix OF
		1 : renseignementGarage(tG);
		2 : renseignementVoiture(tG);
		3 : menuAffichage(tG);
	end;
	effaceEcran();
	menuPrincipal := choix;
end;

// -- Programme Principal --

VAR
	tG : tableauGarage;
	i : integer;
BEGIN
	Randomize;
	effaceEcran();
	FOR i := 1 TO MAXGARAGE DO tG[i].nombreVoitures := 0; // On initialise ici le nombre de voiture par garage.
	WHILE menuPrincipal(tG) <> 0 DO; // Tant que l'utilisateur n'a pas taper 0, il reste dans le programme.
END.
