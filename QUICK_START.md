# 🚀 Quick Start Guide - ScalpingEA MT5 Pro

## 5-Minute Setup

### Step 1: Download & Install
```
1. Download: ScalpingEA_MT5_Pro.mq5
2. Open MetaTrader 5 terminal
3. Press Ctrl+Shift+F to open File Explorer
4. Navigate to: MQL5 → Experts
5. Copy ScalpingEA_MT5_Pro.mq5 into this folder
```

### Step 2: Compile
```
1. Press F11 to open MetaEditor
2. Open ScalpingEA_MT5_Pro.mq5
3. Press F7 to compile
4. Check: Should show "0 errors"
```

### Step 3: Apply to Chart
```
1. Open a 5-minute chart (M5) in MT5
2. Drag the EA from Navigator → Expert Advisors onto chart
3. Select "Balanced" preset from CONFIG_PRESETS.mq5
4. Click OK
5. Done! EA is now running
```

---

## ⚙️ Quick Parameter Setup

### For Beginners (Conservative)
Copy these values into the EA settings:
```
RiskPercent = 0.5
MaxDailyLoss = 2.0
MaxTradesPerDay = 5
MaxSpreadPips = 2.0
```

### For Intermediate (Balanced - Recommended)
```
RiskPercent = 1.0
MaxDailyLoss = 5.0
MaxTradesPerDay = 10
MaxSpreadPips = 5.0
```

### For Advanced (Aggressive)
```
RiskPercent = 2.0
MaxDailyLoss = 10.0
MaxTradesPerDay = 15
MaxSpreadPips = 5.0
```

---

## 📊 What to Expect

### First Week on Demo
- **Trades:** 5-15 trades (depends on market conditions)
- **Win Rate:** Around 55-60%
- **Expected Result:** +1% to +5% return
- **Focus:** Learn the EA behavior, not profits

### First Month Live (Small Position)
- **Start with:** 0.01 lot or micro account
- **Monitor:** All trades in Journal tab
- **Adjust if:** Drawdown > 15% or losing streak > 5 trades
- **Scale up:** Only after 2 weeks of consistent profits

---

## 🎯 How Trades Work

### BUY Signal (Green)
```
When 3 of 4 indicators confirm:
1. Fast EMA crosses above Slow EMA
2. RSI drops below 30 (oversold)
3. MACD main line crosses above signal
4. Price touches lower Bollinger Band

EA opens BUY trade with:
- Stop Loss = 50 pips (example)
- Take Profit = 100 pips
- Position Size = 0.1 lot (example)
```

### SELL Signal (Red)
```
When 3 of 4 indicators confirm:
1. Fast EMA crosses below Slow EMA
2. RSI rises above 70 (overbought)
3. MACD main line crosses below signal
4. Price touches upper Bollinger Band

EA opens SELL trade with:
- Stop Loss = 50 pips
- Take Profit = 100 pips
- Position Size = 0.1 lot
```

---

## 🛑 Safety Features (Automatic)

### ✅ Spread Filter
- Skips trades if spread > 5 pips
- Saves money on wide spreads

### ✅ Daily Loss Limit
- Stops trading if daily loss > 5%
- Prevents catastrophic losses

### ✅ Trade Limit
- Max 10 trades per day
- Prevents over-trading

### ✅ Trading Hours
- Only trades 8 AM - 10 PM GMT
- Avoids low-liquidity hours

---

## 📈 Monitoring Your Trades

### Check Journal Tab (Every Hour)
```
1. Click "Journal" tab in MT5
2. Review recent trades
3. Look for patterns (good/bad entry times)
4. Adjust parameters if needed
```

### Daily Review Checklist
```
□ How many trades today? (should be < 10)
□ Win rate today? (should be > 50%)
□ Largest loss? (should be < 1% of account)
□ Any spread issues?
□ Any unexpected behavior?
```

---

## ⚠️ Common Issues & Fixes

### "No trades are being opened"
**Check:**
- Is current spread > 5 pips? (Check Market Watch)
- Is it between 8 AM - 10 PM GMT?
- Has daily loss limit been hit?
- View Journal for error messages

**Fix:**
```
- Increase MaxSpreadPips to 10
- Disable EnableTimeFilter = false
- Lower daily loss limit
```

### "EA keeps closing trades at loss"
**Likely causes:**
- Spread too wide (EA uses wider SL)
- Indicator settings too sensitive
- Market conditions not suitable

**Fix:**
```
- Use Balanced preset instead of Aggressive
- Increase ATR_Multiplier to 2.0
- Only trade during high-volume hours
```

### "Position sizing seems wrong"
**Check calculation:**
```
Position Size = (1% of Balance) / (SL in pips × tick value)

Example: $1,000 account
- Risk amount: $1,000 × 1% = $10
- SL distance: 50 pips
- EURUSD tick value: $10 per pip
- Position size: $10 / (50 × $10) = 0.01 lot ✓
```

**Fix:**
- Increase RiskPercent if too small
- Decrease MaxSpreadPips to get tighter SL
- Use larger account for reasonable sizes

---

## 💡 Pro Tips

### Tip 1: Test on Demo First
```
Run on demo account for 2 weeks minimum
before going live with real money
```

### Tip 2: Start Small
```
Live trading: Start with 0.01 lot
After 1 month profit: Scale to 0.05 lot
After 3 months profit: Scale to 0.1 lot
```

### Tip 3: Monitor During High-Impact News
```
Major economic news can cause wild swings
Consider disabling EA 30 min before/after:
- NFP (Non-Farm Payroll)
- Interest Rate Decisions
- GDP Releases
```

### Tip 4: Adjust for Market Conditions
```
Trending market: Increase EMA_Slow to 26
Ranging market: Decrease EMA_Slow to 13
High volatility: Increase ATR_Multiplier to 2.0
Low volatility: Decrease ATR_Multiplier to 1.0
```

### Tip 5: Keep Records
```
Weekly: Document settings used
Monthly: Calculate actual win rate, profit factor
Quarterly: Review and optimize parameters
```

---

## 🎓 Learning Resources

### Understanding the Indicators
- **EMA:** Trend direction
- **RSI:** Overbought/oversold conditions
- **MACD:** Momentum and trend changes
- **Bollinger Bands:** Volatility and price extremes

### Market Sessions (Best Trading Times)
```
00:00-08:00 GMT - Asian Session (low volume)
08:00-12:00 GMT - European open (medium volume)
12:00-17:00 GMT - US open + European close (HIGH VOLUME) ⭐
17:00-22:00 GMT - US session (medium volume)
22:00-00:00 GMT - US close (low volume)
```

**Best for scalping:** 12:00-17:00 GMT (highest liquidity, tightest spreads)

---

## ✅ Checklist Before Going Live

- [ ] Downloaded and compiled EA successfully
- [ ] Tested on demo account for 2+ weeks
- [ ] Reviewed 50+ demo trades
- [ ] Win rate is consistently 50%+
- [ ] Understood all parameters
- [ ] Set conservative risk levels first
- [ ] Verified position sizing calculations
- [ ] Checked EA with multiple pairs
- [ ] Tested during different market sessions
- [ ] Read disclaimer and understand risks
- [ ] Only investing money I can afford to lose
- [ ] Set daily stop-out level
- [ ] Will monitor trades regularly

---

## 🚨 When to STOP Trading

Stop the EA immediately if:
- ❌ Consecutive losses > 5 trades
- ❌ Daily drawdown > 10%
- ❌ Multiple spread-related issues
- ❌ Unusual market conditions (gaps, volatility)
- ❌ You don't understand what's happening

**Always take time to review and adjust!**

---

**Good luck! Happy Trading! 📈**

*Remember: Past performance does not guarantee future results. Always use proper risk management.*