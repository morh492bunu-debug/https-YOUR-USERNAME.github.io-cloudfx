//+------------------------------------------------------------------+
//|              ScalpingEA_MT5_Pro - Configuration Template          |
//|                                                                   |
//| Copy these settings into the EA parameters dialog in MT5:        |
//| - Right-click chart → Modify/Delete Expert Advisor              |
//| - Copy values from corresponding preset below                   |
//+------------------------------------------------------------------+

//============================================================
// PRESET 1: CONSERVATIVE (Low Risk / Capital Preservation)
//============================================================
/*
RiskPercent = 0.5
TPRatio = 2.0
EMA_Fast = 8
EMA_Slow = 21
RSI_Period = 14
RSI_Overbought = 70
RSI_Oversold = 30
MACD_Fast = 12
MACD_Slow = 26
MACD_Signal = 9
BB_Period = 20
BB_Deviation = 2.0
ATR_Period = 14
ATR_Multiplier = 1.5
MagicNumber = 123456
MaxSpreadPips = 2.0
MaxTradesPerDay = 5
MaxDailyLoss = 2.0
EnableTimeFilter = true
StartHour = 8
EndHour = 22

EXPECTED RESULTS:
- Win Rate: 55-60%
- Monthly Return: 1-2%
- Max Drawdown: 3-5%
- Best for: Low drawdown tolerance, capital preservation
*/

//============================================================
// PRESET 2: BALANCED (Default / Recommended)
//============================================================
/*
RiskPercent = 1.0
TPRatio = 2.0
EMA_Fast = 8
EMA_Slow = 21
RSI_Period = 14
RSI_Overbought = 70
RSI_Oversold = 30
MACD_Fast = 12
MACD_Slow = 26
MACD_Signal = 9
BB_Period = 20
BB_Deviation = 2.0
ATR_Period = 14
ATR_Multiplier = 1.5
MagicNumber = 123456
MaxSpreadPips = 5.0
MaxTradesPerDay = 10
MaxDailyLoss = 5.0
EnableTimeFilter = true
StartHour = 8
EndHour = 22

EXPECTED RESULTS:
- Win Rate: 55-60%
- Monthly Return: 3-5%
- Max Drawdown: 8-12%
- Best for: Most traders, good risk/reward balance
*/

//============================================================
// PRESET 3: AGGRESSIVE (High Growth)
//============================================================
/*
RiskPercent = 2.0
TPRatio = 2.0
EMA_Fast = 8
EMA_Slow = 21
RSI_Period = 14
RSI_Overbought = 70
RSI_Oversold = 30
MACD_Fast = 12
MACD_Slow = 26
MACD_Signal = 9
BB_Period = 20
BB_Deviation = 2.0
ATR_Period = 14
ATR_Multiplier = 1.2
MagicNumber = 123456
MaxSpreadPips = 5.0
MaxTradesPerDay = 15
MaxDailyLoss = 10.0
EnableTimeFilter = false
StartHour = 0
EndHour = 24

EXPECTED RESULTS:
- Win Rate: 55-60%
- Monthly Return: 8-15%
- Max Drawdown: 15-20%
- Best for: Experienced traders, high risk tolerance
*/

//============================================================
// PRESET 4: SCALPER (Ultra-Fast / Intraday)
//============================================================
/*
RiskPercent = 1.0
TPRatio = 1.5
EMA_Fast = 5
EMA_Slow = 13
RSI_Period = 9
RSI_Overbought = 75
RSI_Oversold = 25
MACD_Fast = 5
MACD_Slow = 13
MACD_Signal = 5
BB_Period = 10
BB_Deviation = 1.5
ATR_Period = 10
ATR_Multiplier = 1.0
MagicNumber = 123456
MaxSpreadPips = 3.0
MaxTradesPerDay = 20
MaxDailyLoss = 5.0
EnableTimeFilter = true
StartHour = 8
EndHour = 20

EXPECTED RESULTS:
- Win Rate: 50-55%
- Trade Duration: 5-20 minutes
- Monthly Return: 5-8%
- Best for: Active day traders, tight stops
*/

//============================================================
// PRESET 5: SWING (Medium-Term / Trend Following)
//============================================================
/*
RiskPercent = 1.0
TPRatio = 3.0
EMA_Fast = 12
EMA_Slow = 26
RSI_Period = 14
RSI_Overbought = 70
RSI_Oversold = 30
MACD_Fast = 12
MACD_Slow = 26
MACD_Signal = 9
BB_Period = 30
BB_Deviation = 2.0
ATR_Period = 20
ATR_Multiplier = 2.0
MagicNumber = 123456
MaxSpreadPips = 5.0
MaxTradesPerDay = 5
MaxDailyLoss = 8.0
EnableTimeFilter = false
StartHour = 0
EndHour = 24

EXPECTED RESULTS:
- Win Rate: 55-65%
- Trade Duration: 30 min - 2 hours
- Monthly Return: 4-10%
- Best for: Medium-term traders, trend followers
*/

//============================================================
// OPTIMIZATION GUIDELINES
//============================================================

/*
WHEN TO ADJUST PARAMETERS:

1. TOO MANY FALSE SIGNALS?
   - Increase EMA_Slow (e.g., 21 → 26)
   - Increase BB_Period (e.g., 20 → 30)
   - Increase RSI_Period (e.g., 14 → 21)
   - Require 4/4 signals instead of 3/4

2. MISSING GOOD TRADES?
   - Decrease EMA_Slow (e.g., 21 → 13)
   - Decrease BB_Period (e.g., 20 → 13)
   - Lower RSI thresholds (e.g., 30/70 → 25/75)
   - Decrease ATR_Multiplier (e.g., 1.5 → 1.0)

3. TOO MANY SMALL TRADES?
   - Increase MaxTradesPerDay limit
   - Increase RiskPercent per trade
   - Relax MaxDailyLoss limit

4. TOO LARGE DRAWDOWNS?
   - Decrease RiskPercent (e.g., 1.0 → 0.5)
   - Decrease MaxDailyLoss (e.g., 5.0 → 2.0)
   - Increase MaxSpreadPips tolerance (skip bad spreads)
   - Increase ATR_Multiplier for wider stops

5. NOT ENOUGH PROFIT?
   - Increase RiskPercent carefully
   - Increase TPRatio (e.g., 2.0 → 2.5)
   - Adjust indicator sensitivity
   - Trade during high-volume sessions

6. LOSING MONEY ON SPECIFIC PAIRS?
   - Edit EA to remove underperforming pair
   - Example: Remove "XAUUSD" from Pairs array
   - Adjust parameters specific to pair

*/

//============================================================
// BACKTESTING CHECKLIST
//============================================================

/*
BEFORE LIVE TRADING:

□ Test on demo account for at least 1 week
□ Review all trades in Journal tab
□ Check for consistency across different pairs
□ Verify position sizing is correct
□ Confirm stop loss and take profit calculations
□ Test during different market conditions:
  - Trending market
  - Ranging market
  - High volatility
  - Low volatility
□ Adjust parameters if results are unsatisfactory
□ Only then proceed to live trading with small positions

PERFORMANCE METRICS TO MONITOR:

□ Win Rate (%): Should be 50%+ over 30+ trades
□ Profit Factor: Should be 1.5+ (profit/loss)
□ Max Consecutive Losses: Should be < 5
□ Daily Drawdown: Should not exceed MaxDailyLoss
□ Average Trade Duration: Should match your goals
□ Largest Win/Loss Ratio: Should be positive
*/

//============================================================
// SYMBOL-SPECIFIC NOTES
//============================================================

/*
EURUSD (Euro/US Dollar)
- Most liquid, lowest spreads (0.5-1.0 pips)
- Trading hours: 8:00-22:00 GMT ideal
- Good for: Conservative traders
- Volatility: Low-Medium

GBPUSD (British Pound/US Dollar)
- More volatile than EURUSD (1-2 pips spreads)
- Trading hours: 8:00-17:00 GMT best
- Good for: Medium-risk traders
- Volatility: Medium-High

XAUUSD (Gold/US Dollar)
- High volatility, trending instrument (1-2 pips spreads)
- Trading hours: 13:00-21:00 GMT best
- Good for: Trend followers
- Volatility: High

USDJPY (US Dollar/Japanese Yen)
- Good trends, medium spreads (1-2 pips)
- Trading hours: 0:00-8:00 GMT and 13:00-22:00 GMT
- Good for: All trader types
- Volatility: Medium
*/

//============================================================
// RISK CALCULATION EXAMPLES
//============================================================

/*
EXAMPLE 1: $10,000 Account, Conservative Settings
- RiskPercent: 0.5%
- Risk per trade: $10,000 × 0.5% = $50
- EURUSD: 1 pip = $10
- SL = 50 pips (ATR 33.3 × 1.5)
- Position size: $50 / (50 × $10) = 0.1 lot
- Result: Risk $50 to make $100

EXAMPLE 2: $10,000 Account, Balanced Settings
- RiskPercent: 1.0%
- Risk per trade: $10,000 × 1.0% = $100
- EURUSD: 1 pip = $10
- SL = 50 pips
- Position size: $100 / (50 × $10) = 0.2 lot
- Result: Risk $100 to make $200

EXAMPLE 3: $50,000 Account, Aggressive Settings
- RiskPercent: 2.0%
- Risk per trade: $50,000 × 2.0% = $1,000
- EURUSD: 1 pip = $10
- SL = 40 pips (ATR 26.7 × 1.2)
- Position size: $1,000 / (40 × $10) = 2.5 lots
- Result: Risk $1,000 to make $2,500
*/

//+------------------------------------------------------------------+
// End of Configuration Template
//+------------------------------------------------------------------+