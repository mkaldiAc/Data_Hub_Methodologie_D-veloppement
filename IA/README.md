# Directives normatives pour les IA — DATA HUB

Version de travail V0.1 — atelier du 24/11/2026. Lire ce fichier, puis `framework-procedure-stockee.md`, `trame-procedure-stockee.sql` et `decisions-et-chantiers.md` avant de créer ou modifier une procédure stockée SQL Server.

## Mission
Produire des scripts SQL Server/Azure SQL **lisibles par les développeurs**, **analysables par une IA de lignage**, **observables**, **robustes** et **homogènes**. Le dictionnaire de données est un consommateur du code, non l'objet de cette méthodologie.

## Autorité et statuts
- **VALIDÉ (principe)** : orientation explicitement approuvée collectivement durant l'atelier ; appliquer.
- **PROPOSÉ (à arbitrer)** : choix technique ou chiffre précis suggéré par l'assistant, pas encore entériné ; demander validation ou signaler l'hypothèse.
- **DIFFÉRÉ** : hors du périmètre actuel, ne pas inventer une norme.

La priorité est la justesse fonctionnelle et l'intégrité des données, puis la lisibilité, l'observabilité et la performance mesurée. Les exceptions de performance se justifient et se documentent, sans masquer les écarts.

## Contrat impératif pour chaque IA
1. Préserver les règles de gestion et le résultat des traitements existants ; ne pas les réinterpréter sans validation.
2. Décomposer les traitements en blocs fonctionnels nommés, CTE préparatoires et étapes matérialisées si utiles, assemblage, chargement et post-traitement.
3. Rendre visibles les sources, les jointures, les filtres, la granularité et les calculs. Commenter la **méthode de calcul**, pas inventer les usages métier.
4. Prévoir le monitoring global et par étapes, les temps, les volumes, les messages d'exécution SSMS, les erreurs et les mécanismes de rollback.
5. Placer en tête des exemples `EXEC` commentés avec paramètres nommés, sûrs et adaptés.
6. Appliquer la charte de présentation **une fois les mesures exactes validées** ; d'ici là utiliser le gabarit proposé, en indiquant son statut.
7. Ne pas copier des anti-patterns des exemples historiques : les procédures étudiées sont un matériau, pas une autorité supérieure.
8. Pour chaque modification, restituer les impacts, les tests nécessaires et les écarts éventuels au standard.
9. Les procédures de monitoring existantes doivent être examinées avant toute adaptation de leur signature ; ne pas supposer qu'elles supportent statut d'échec ou volumes.

## Fichiers
- [Framework](framework-procedure-stockee.md)
- [Trame T-SQL](trame-procedure-stockee.sql)
- [Décisions et chantiers](decisions-et-chantiers.md)

L'application `Humain/Application/index.html` est une représentation de consultation ; en cas de contradiction, le référentiel IA gouverne, après décision humaine. Les évolutions validées doivent mettre à jour les deux supports.
