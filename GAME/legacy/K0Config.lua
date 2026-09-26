-- Baycrest K0. Production values mirror EKIP/03-EKONOMI.md section 14.
-- Prototype values compress the loop for an internal 20 minute play session.
return {
	Production = {
		ShiftSeconds = 2880,
		LevelNetPerMinute = {20, 40, 85, 110, 140},
		LevelCost = {1500, 5000, 15000, 45000, 150000},
		BaseSalaryRate = 0.07,
		HappyWorkerEfficiency = 0.35,
	},
	Prototype = {
		SaleReward = 250,
		CustomerWalkSeconds = 3,
		CustomerGapSeconds = 2,
		CustomerPatienceSeconds = 30,
		WorkerServeSeconds = 7,
		ShiftSeconds = 180,
		InteractionDistance = 15,
	},
}
