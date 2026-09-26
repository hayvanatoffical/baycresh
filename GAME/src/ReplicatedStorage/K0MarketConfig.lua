-- Baycrest K0 market vertical slice.
-- Production values remain separate from compressed prototype values so playtest
-- tuning cannot be mistaken for the live economy baseline.
return {
    Version = "K0-market-0.3.0",

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
        PlaytestSeed = 260926,
        TargetSessionSeconds = 1200,

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
