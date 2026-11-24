# Framework SQL Server — procédures stockées

Version V0.1 de travail (24/11/2026). Origine : atelier collectif, exemples étudiés : `DWH.Proc_Releve_compte_client_historique`, `DWH.Proc_Equipement_mesure`, `DWH.Proc_Bail`.

## 1. Principes VALIDÉS
- **Lisibilité avant concision excessive** : éviter les requêtes monolithiques et les sous-requêtes profondément imbriquées ; favoriser la décomposition fonctionnelle.
- **Architecture préférentielle** : CTE de calcul/préparation → matérialisation intermédiaire lorsque pertinente → CTE / jeu d'assemblage → insertion ou mise à jour de la cible → post-traitements éventuels. Pour les historiques, envelopper les étapes récurrentes dans une boucle contrôlée.
- **Inspection** : utiliser des tables temporaires pour consulter les étapes intermédiaires et permettre le suivi séparé ; attention, une CTE SQL Server n'est **pas** matérialisée par elle-même.
- **Performance** : ne pas sacrifier fortement la durée des traitements à la décomposition ; démontrer les écarts par mesures et documenter les exceptions.
- **Commentaires** : expliquer sources, périmètre, règles de calcul, exceptions, substitutions, transformations et granularité. Faciliter le lignage machine ; l'interprétation métier définitive appartient aux métiers.
- **Suivi** : monitoring persistant début/fin global ET étapes principales ; mesurer les temps afin de détecter les goulets d'étranglement.
- **Résultats en SSMS** : afficher les étapes, durées et volumes de lignes préparées, insérées, modifiées, supprimées ; comptabiliser les itérations/paquets si nécessaire.
- **Fiabilité** : gestion d'erreurs, transactions adaptées, rollback pour éviter les états incohérents ; penser à la survie des logs d'erreur au rollback.
- **En tête** : fournir un ou plusieurs `EXEC` commentés avec paramètres explicitement nommés.
- **Homogénéité visuelle stricte** : séparateurs, indentation, espacements et sauts de ligne identiques entre procédures ; ne pas multiplier les lignes vides.
- **Code compact et lisible** : grouper raisonnablement les listes `IN (...)` longues sur peu de lignes au lieu d'une valeur par ligne.

## 2. Architecture de référence (principe VALIDÉ, détail PROPOSÉ)
1. Exemples d'exécution commentés, en-tête (objet, finalité de transformation, sources, destination, granularité, modes et règles de calcul).
2. Déclaration des paramètres et initialisation ; validation des entrées, date de référence et identifiant d'exécution.
3. Démarrage monitoring global, puis `TRY`.
4. Préparation : CTE spécialisées nommées, éventuellement `SELECT ... INTO #...`, index temporaires si justifiés ; suivi de durée / volume entre étapes.
5. Assemblage des résultats vers un jeu final, avec noms de champs explicites.
6. Contrôles avant écriture : clé/granularité, doublons, valeurs anormales, cohérence de période.
7. Transaction couvrant l'ensemble des écritures qui doivent être atomiques. Favoriser la préparation hors transaction **si** elle est compatible avec la cohérence des sources.
8. Insertion / mise à jour / suppression et post-traitement, avec volumes exacts.
9. `COMMIT`, fin du monitoring et message de succès.
10. `CATCH` : relever les détails de l'erreur, `ROLLBACK` si `XACT_STATE() <> 0`, tracer hors transaction annulée, puis `THROW`.

### Variantes
- **Historique** : boucle par mois ou période avec bornes explicites, cumuls par itération, monitoring mois + étape ; déterminer le périmètre atomique (toute la série ou chaque période) selon risque/volumes.
- **Reconstruction totale** : ne jamais effectuer `TRUNCATE` suivi d'un `INSERT` hors protection transactionnelle appropriée ; une table de préparation/staging peut réduire la durée des verrous si pertinente.
- **Incrémental** : préciser la clé métier, le périmètre de suppression/modification et l'idempotence.

## 3. Détails techniques PROPOSÉS — validation à venir
- Utiliser `SET NOCOUNT ON; SET XACT_ABORT ON;`, `TRY/CATCH`, `XACT_STATE()`, `THROW`. L'option `NOCOUNT` supprime les messages automatiques de lignes affectées : **les volumes sont émis explicitement**.
- Capturer `@@ROWCOUNT` **immédiatement** après chaque DML ou `SELECT INTO` dans une variable ; ne pas laisser un `SET`, `EXEC` ou message l'écraser.
- Pour afficher immédiatement les étapes dans SSMS : `RAISERROR(N'...', 0, 1) WITH NOWAIT` en information ; ne pas employer une sévérité d'erreur pour le suivi.
- Mesurer les temps par `SYSUTCDATETIME()` / `DATEDIFF_BIG(MILLISECOND, debut, fin)` ; capturer un instant métier de référence à l'initialisation si plusieurs calculs doivent partager le même « aujourd'hui ». Choix exact des fonctions différé.
- Journaliser la fin en erreur **après rollback** ; une écriture de log dans la même transaction que le traitement disparaît avec le rollback.
- Utiliser des identifiants d'exécution robustes à la concurrence et des étiquettes d'étape constantes. Ne pas présumer du contrat de `[MONITORING].[ProcMaj_DWH_ProcExec]` ; examiner son schéma et son comportement avant intégration.
- Les validations de volumes/doublons doivent dépendre du métier et du mode de chargement ; aucun seuil arbitraire global.

## 4. Charte visuelle PROPOSÉE — valeurs non encore votées
Les principes d'uniformité sont VALIDÉS ; **les constantes ci-dessous ne le sont pas encore** :
- 4 espaces par niveau d'indentation ; pas de tabulations.
- Grands titres : 3 lignes de commentaires avec un trait de 80 tirets, titre, trait de 80 tirets.
- Une ligne vide avant et après un grand titre ; **une seule** ligne vide entre étapes/CTE indépendantes ; pas de lignes vides entre chaque colonne sélectionnée.
- Mettre les clauses `SELECT`, `FROM`, `JOIN`, `WHERE`, `GROUP BY` à un niveau prévisible ; une expression par ligne si elle est complexe, des `IN` courts groupés.
- Garder des alias sémantiques (ex. `Ecriture_client`, `Bail`) stables dans la portée ; ne pas masquer la provenance des colonnes.
- Chaque section porte un nom explicite et, si elle fait l'objet d'un log, un identifiant stable.

## 5. Contrôles qualité avant validation
- La procédure compile et fonctionne en DEV avec cas normal, données vides, erreurs provoquées, rejeu et volumes réalistes.
- Résultats métier identiques avant/après refactorisation ; grain, doublons, clés et nulls vérifiés.
- Une interruption ne laisse pas la table cible dans un état invalide ; logs d'échec préservés si le contrat de monitoring le permet.
- Monitoring global et détaillé cohérent ; temps et volumes vérifiés avec `@@ROWCOUNT`.
- Lecture possible de la provenance et des étapes de transformation sans dépendre d'un commentaire opaque.
- Tests de performance comparatifs en DEV sur périmètre représentatif, particulièrement sur la matérialisation temporaire et les transactions.
- Présentation conforme au gabarit choisi ; éventuel écart documenté.

Le fichier `trame-procedure-stockee.sql` montre une structure pédagogique, **pas** la signature effective de la procédure de monitoring existante.
