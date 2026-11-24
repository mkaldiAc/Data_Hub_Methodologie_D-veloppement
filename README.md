# DATA HUB — Méthodologie de développement SQL Server

Référentiel collaboratif de l'équipe DATA. Première formalisation issue de l'atelier du **24 novembre 2026**.

## Organisation

- [IA/README.md](IA/README.md) — instructions d'entrée pour ChatGPT, Claude et les autres IA.
- [IA/framework-procedure-stockee.md](IA/framework-procedure-stockee.md) — principes, architecture et règles de développement SQL.
- [IA/trame-procedure-stockee.sql](IA/trame-procedure-stockee.sql) — squelette pédagogique de procédure stockée.
- [IA/decisions-et-chantiers.md](IA/decisions-et-chantiers.md) — éléments validés, arbitrages et sujets différés.
- [Humain/Application/index.html](Humain/Application/index.html) — application HTML autonome de consultation du framework.

## Utilisation

**Assistants IA** : lire d'abord `IA/README.md`, puis les trois ressources liées. Appliquer les règles validées et distinguer les propositions non encore arbitrées.

**Équipe DATA** : ouvrir `Humain/Application/index.html` localement dans un navigateur (téléchargement du fichier) pour rechercher, filtrer et consulter le référentiel. Le HTML GitHub peut aussi être consulté en source, mais la page GitHub d'un fichier HTML n'exécute pas nécessairement son interface.

## Statut V0.1 de travail

Les principes communs sont issus des échanges de l'atelier. Les détails techniques et les constantes exactes de présentation restent **proposés**, non validés. Le chantier « fonctions et méthodes SQL » (`GETDATE`, dates, `APPLY`...) est **différé**. La trame n'est pas une procédure de production prête à l'emploi.

Les trois procédures étudiées : `DWH.Proc_Releve_compte_client_historique`, `DWH.Proc_Equipement_mesure`, `DWH.Proc_Bail`. Ces exemples ne sont pas reproduits dans ce dépôt.

**Gouvernance :** les conventions validées dans `IA/` constituent la source pour la génération de code ; mettre à jour l'interface humaine simultanément lors de chaque évolution validée.
