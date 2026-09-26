-- Baycrest K0 market vertical slice.
-- Production values remain separate from compressed prototype values so playtest
-- tuning cannot be mistaken for the live economy baseline.
return {
    Version = "K0-market-0.4.1",

    Production = {
        ShiftSeconds = 2880,
        LevelCost = {1500, 5000, 15000, 45000, 150000},
        BaseSalaryRate = 0.07,
        HappyWorkerEfficiency = 0.35,
    },

    Prototype = {
        StartingCash = 180,
        PermitFee = 70,
        PermitPeriodSeconds = 1320, -- 22 min: K0 gate finishes before renewal friction appears
        UpgradeCost = 250,
        HireCost = 60,
        WagePerShift = 45,
        ShiftSeconds = 240,
        InteractionDistance = 15,

        -- Controlled K0 playtests should be comparable across participants.
        -- Only gameplay randomness uses this seed; decorative crowd randomness is separate.
        -- K0.4: the economy stream is drawn only while commerce can actually serve a
        -- customer, so setup speed no longer shifts the sequence between testers.
        PlaytestSeed = 260926,
        TargetSessionSeconds = 1200,

        -- K0.4 recovery rules. A 20-minute measurement must never end in a state the
        -- player cannot act on, otherwise the test stops measuring the core loop.
        -- Liquidation is the player's own decision; the rescue grant is a bounded,
        -- telemetered guard rail and is NOT a production economy rule.
        LiquidationRatio = 0.5,
        RescueGrantLimit = 1,
        DecisionRateLimit = 6,      -- accepted decision events per window
        DecisionRateWindow = 3,     -- seconds

        ArrivalGapMin = 8,
        ArrivalGapMax = 16,
        ShopperWalkMin = 3,
        ShopperWalkMax = 6,
        PatienceMin = 20,
        PatienceMax = 32,
        WorkerResponseSeconds = 6,
        CrowdGapMin = 5,
        CrowdGapMax = 11,

        -- K0 decision loop: visible demand changes which stock is more attractive.
        DemandCycleSeconds = 60,
        DemandBonusRatio = 0.15,
        DemandPickChance = 0.70,

        -- Bargaining is deterministic after the customer is created. The player
        -- sees a budget signal, so a rejected counter-offer is explainable rather
        -- than a hidden coin flip.
        BargainBidRatio = 0.78,
        BargainCounterRatio = 0.90,
        BargainProfiles = {
            {Name = "Sıkı bütçe", Hint = "SIKI", Weight = 35, MaxRatio = 0.86},
            {Name = "Normal bütçe", Hint = "ORTA", Weight = 45, MaxRatio = 0.94},
            {Name = "Esnek bütçe", Hint = "ESNEK", Weight = 20, MaxRatio = 1.00},
        },

        VisitorWeights = {Passerby = 30, Browser = 20, Buyer = 32, Bargainer = 18},

        -- Invariant: WholesaleCost must divide evenly by WholesaleBundle so a partial
        -- restock is priced per unit without rounding drift (orange 6 ₡, bread 8 ₡).
        -- Level1Capacity equals one bundle on purpose: the shelf is one bundle deep
        -- until the upgrade. K0.3 combined that with a whole-bundle-only purchase, so
        -- a single leftover unit locked the shelf permanently. K0.4 keeps the capacity
        -- and buys only what fits instead. validate_package.py enforces the divisibility
        -- and that capacity is never smaller than a bundle.
        Products = {
            orange = {
                Name = "Portakal",
                Unit = "kg",
                Retail = 14,
                WholesaleBundle = 8,
                WholesaleCost = 48,
                Level1Capacity = 8,
                Level2Capacity = 16,
            },
            bread = {
                Name = "Ekmek",
                Unit = "adet",
                Retail = 18,
                WholesaleBundle = 6,
                WholesaleCost = 48,
                Level1Capacity = 6,
                Level2Capacity = 12,
            },
        },
    },
}
