# Décisions, arbitrages et prochaines séances

## VALIDÉ dans l'atelier du 24/11/2026
1. Standardiser les pratiques SQL Server de toute l'équipe, y compris les développements assistés par ChatGPT ou Claude.
2. Lisibilité humaine, code interprétable par IA pour le lignage et les règles de transformation ; ne pas définir le dictionnaire de données lui-même.
3. Découpage CTE / étapes intermédiaires / assemblage / chargement / post-traitement privilégié, avec exceptions motivées par des performances mesurées.
4. Monitoring persistant de durée global et par étape ; gestion des erreurs, rollback et cohérence transactionnelle.
5. Messages SSMS sur étapes et nombres de lignes affectées/traitées/insérées.
6. Exemples `EXEC` commentés en tête de script.
7. Charte visuelle **strictement identique** entre procédures : espacement, sauts de ligne, indentations, séparateurs, style.
8. Création des zones `IA/` (source de normes pour assistants) et `Humain/Application/` (consultation HTML).

## PROPOSÉ, À ARBITRER
- Dimensions exactes de la charte visuelle (80 tirets, 4 espaces, une ligne vide).
- Messages instantanés `RAISERROR ... WITH NOWAIT`, gestion `SET NOCOUNT ON`, format des durées et libellés.
- Identifiant unique d'exécution / clés des logs, niveaux et signatures des procédures de monitoring.
- Stratégie transactionnelle pour les historiques longs (globale vs par période) ; survie des logs en erreur.
- Critères obligatoires de matérialisation, d'indexation des temporaires et de bascule vers des traitements optimisés.
- Critères de vérification automatique de la charte (lint/format).
- Conditions de migration des procédures existantes et jeux de tests minimaux.

## DIFFÉRÉ : bibliothèque de méthodes SQL
Travail à mener ultérieurement, distinct du framework structural :
- Instant de référence cohérent pour les règles de calcul ; différence entre heure métier figée et chronomètre d'étapes.
- Conversions de dates, bornes de périodes, calendriers, fuseaux, gestion des valeurs sources atypiques.
- `CROSS APPLY` et `OUTER APPLY` : cas d'emploi, alternatives et performance.
- Conventions de fonctions SQL pour une opération donnée ; `GETDATE`, `SYSDATETIME`, `CONVERT`, `TRY_CONVERT`, `DATEADD`, `EOMONTH`, etc.
- Autres conventions identifiées lors des revues de scripts.

## Références de l'atelier
- `DWH.Proc_Releve_compte_client_historique` : boucle historique, CTE préparatoires, assemblage, post-traitement et monitoring étagé.
- `DWH.Proc_Equipement_mesure` : pipeline de transformation, matérialisations, transaction et `TRY/CATCH`.
- `DWH.Proc_Bail` : procédure plus simple, préparation, insertion et post-traitement ; risque d'effacement de cible avant échec à corriger.

Les exemples sont étudiés comme sources de bonnes pratiques **et de points d'amélioration**, sans validation implicite de tous leurs choix techniques.
