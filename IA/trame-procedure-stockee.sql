-- EXEC [DWH].[Proc_Exemple_framework] @Date_reference = '2026-11-24';
-- Exemple pédagogique : remplacer objets, champs, étapes et règles métier avant utilisation.
-- PROPOSÉ : mise en forme et choix techniques détaillés non encore validés.

CREATE OR ALTER PROCEDURE [DWH].[Proc_Exemple_framework]
    @Date_reference DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Date_traitement DATE = COALESCE(@Date_reference, CONVERT(DATE, SYSDATETIME()));
    DECLARE @Debut_global DATETIME2(3) = SYSUTCDATETIME();
    DECLARE @Debut_etape DATETIME2(3);
    DECLARE @Lignes BIGINT = 0;
    DECLARE @Duree_ms BIGINT;
    DECLARE @Message NVARCHAR(2047);

    -- --------------------------------------------------------------------------------
    -- 1. INITIALISATION ET MONITORING GLOBAL
    -- --------------------------------------------------------------------------------
    -- À intégrer : [MONITORING].[ProcMaj_DWH_ProcExec] avec la vraie signature vérifiée.
    RAISERROR(N'DÉBUT Proc_Exemple_framework', 0, 1) WITH NOWAIT;

    BEGIN TRY
        -- --------------------------------------------------------------------------------
        -- 2. PRÉPARATION : CTE ET TABLE TEMPORAIRE
        -- --------------------------------------------------------------------------------
        SET @Debut_etape = SYSUTCDATETIME();

        -- Exemple volontairement sans table métier réelle : adapter les sources.
        ;WITH CTE_SOURCE AS (
            SELECT CAST(1 AS INT) AS ID_exemple, @Date_traitement AS Date_reference
        )
        SELECT ID_exemple, Date_reference INTO #CTE_SOURCE FROM CTE_SOURCE;
        SET @Lignes = @@ROWCOUNT;
        SET @Duree_ms = DATEDIFF_BIG(MILLISECOND, @Debut_etape, SYSUTCDATETIME());
        SET @Message = CONCAT(N'PRÉPARATION | lignes préparées=', @Lignes, N' | durée_ms=', @Duree_ms);
        RAISERROR(@Message, 0, 1) WITH NOWAIT;

        -- --------------------------------------------------------------------------------
        -- 3. ASSEMBLAGE : JEU FINAL INSPECTABLE
        -- --------------------------------------------------------------------------------
        SET @Debut_etape = SYSUTCDATETIME();
        ;WITH CTE_ASSEMBLAGE AS (
            SELECT Source_donnee.ID_exemple, Source_donnee.Date_reference
            FROM #CTE_SOURCE AS Source_donnee
        )
        SELECT ID_exemple, Date_reference INTO #CTE_ASSEMBLAGE FROM CTE_ASSEMBLAGE;
        SET @Lignes = @@ROWCOUNT;
        SET @Duree_ms = DATEDIFF_BIG(MILLISECOND, @Debut_etape, SYSUTCDATETIME());
        SET @Message = CONCAT(N'ASSEMBLAGE | lignes préparées=', @Lignes, N' | durée_ms=', @Duree_ms);
        RAISERROR(@Message, 0, 1) WITH NOWAIT;

        -- --------------------------------------------------------------------------------
        -- 4. CONTRÔLES ET CHARGEMENT TRANSACTIONNEL
        -- --------------------------------------------------------------------------------
        -- Contrôles de grain, unicité et périmètre à définir par objet.
        -- Ajouter BEGIN TRANSACTION / INSERT / UPDATE / DELETE / COMMIT ci-dessous,
        -- uniquement après avoir configuré une vraie table cible et ses règles.
        -- Capturer @@ROWCOUNT immédiatement après chaque instruction de modification.

        -- --------------------------------------------------------------------------------
        -- 5. POST-TRAITEMENT ET FIN
        -- --------------------------------------------------------------------------------
        -- Post-traitements conditionnels si requis par le calcul.
        SET @Duree_ms = DATEDIFF_BIG(MILLISECOND, @Debut_global, SYSUTCDATETIME());
        SET @Message = CONCAT(N'FIN OK | durée_totale_ms=', @Duree_ms);
        RAISERROR(@Message, 0, 1) WITH NOWAIT;
        -- À intégrer : fermeture du monitoring persistant après validation du contrat.
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        -- Journal d'échec HORS transaction annulée, après vérification du contrat.
        SET @Message = CONCAT(N'ÉCHEC | erreur=', ERROR_NUMBER(), N' | étape/ligne=', ERROR_LINE());
        RAISERROR(@Message, 0, 1) WITH NOWAIT;
        THROW;
    END CATCH;
END;
