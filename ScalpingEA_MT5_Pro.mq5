//+------------------------------------------------------------------+
//|                    ScalpingEA_MT5_Pro.mq5                         |
//|           Multi-Pair Scalper: EMA + RSI + MACD + BB              |
//|    Pairs: EURUSD, GBPUSD, XAUUSD, USDJPY                         |
//|    Risk: 1% per trade | TP = 2x SL | Enhanced Risk Management   |
//|    v2.0 - Fixed BB buffer indices, added safety checks           |
//+------------------------------------------------------------------+
#property copyright "Advanced Scalping EA"
#property version   "2.00"
#property description "Professional MT5 Scalping EA with multi-indicator confirmation"

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>

CTrade trade;

//--- Input Parameters - Trading
input double RiskPercent    = 1.0;    // Risk % per trade
input double TPRatio        = 2.0;    // TP = TPRatio x SL
input int    EMA_Fast       = 8;      // Fast EMA period
input int    EMA_Slow       = 21;     // Slow EMA period
input int    RSI_Period     = 14;     // RSI period
input double RSI_Overbought = 70.0;   // RSI overbought level
input double RSI_Oversold   = 30.0;   // RSI oversold level
input int    MACD_Fast      = 12;     // MACD fast EMA
input int    MACD_Slow      = 26;     // MACD slow EMA
input int    MACD_Signal    = 9;      // MACD signal period
input int    BB_Period      = 20;     // Bollinger Bands period
input double BB_Deviation   = 2.0;    // Bollinger Bands deviation
input int    ATR_Period     = 14;     // ATR period for SL calculation
input double ATR_Multiplier = 1.5;    // ATR multiplier for SL

//--- Input Parameters - Risk Management
input ulong  MagicNumber    = 123456; // Unique magic number
input double MaxSpreadPips  = 5.0;    // Maximum spread in pips
input int    MaxTradesPerDay = 10;    // Maximum trades per day
input double MaxDailyLoss   = 5.0;    // Maximum daily loss %
input bool   EnableTimeFilter = true; // Enable trading time restrictions
input int    StartHour      = 8;      // Start trading hour (GMT)
input int    EndHour        = 22;     // End trading hour (GMT)

//--- Pairs
string Pairs[] = {"EURUSD", "GBPUSD", "XAUUSD", "USDJPY"};

//--- Indicator handles per pair
int EmaFastHandle[];
int EmaSlowHandle[];
int RsiHandle[];
int MacdHandle[];
int BbHandle[];
int AtrHandle[];
datetime LastBarTime[];

//--- Trading statistics
int DailyTradeCount = 0;
datetime LastResetTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization                                             |
//+------------------------------------------------------------------+
int OnInit()
{
   int n = ArraySize(Pairs);
   ArrayResize(EmaFastHandle, n);
   ArrayResize(EmaSlowHandle, n);
   ArrayResize(RsiHandle,     n);
   ArrayResize(MacdHandle,    n);
   ArrayResize(BbHandle,      n);
   ArrayResize(AtrHandle,     n);
   ArrayResize(LastBarTime,   n);

   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(10);

   for(int i = 0; i < n; i++)
   {
      string s = Pairs[i];
      EmaFastHandle[i] = iMA(s, PERIOD_M5, EMA_Fast, 0, MODE_EMA, PRICE_CLOSE);
      EmaSlowHandle[i] = iMA(s, PERIOD_M5, EMA_Slow, 0, MODE_EMA, PRICE_CLOSE);
      RsiHandle[i]     = iRSI(s, PERIOD_M5, RSI_Period, PRICE_CLOSE);
      MacdHandle[i]    = iMACD(s, PERIOD_M5, MACD_Fast, MACD_Slow, MACD_Signal, PRICE_CLOSE);
      BbHandle[i]      = iBands(s, PERIOD_M5, BB_Period, 0, BB_Deviation, PRICE_CLOSE);
      AtrHandle[i]     = iATR(s, PERIOD_M5, ATR_Period);
      LastBarTime[i]   = 0;

      if(EmaFastHandle[i] == INVALID_HANDLE || EmaSlowHandle[i] == INVALID_HANDLE ||
         RsiHandle[i]     == INVALID_HANDLE || MacdHandle[i]     == INVALID_HANDLE ||
         BbHandle[i]      == INVALID_HANDLE || AtrHandle[i]      == INVALID_HANDLE)
      {
         PrintFormat("Failed to create indicator handles for %s. Error: %d", s, GetLastError());
         return(INIT_FAILED);
      }
   }

   Print("============================================");
   Print("ScalpingEA MT5 Pro v2.0 Initialized");
   Print("Risk per trade: ", RiskPercent, "%");
   Print("Max daily loss: ", MaxDailyLoss, "%");
   Print("Max trades per day: ", MaxTradesPerDay);
   Print("Time filter enabled: ", EnableTimeFilter);
   Print("============================================");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   for(int i = 0; i < ArraySize(Pairs); i++)
   {
      IndicatorRelease(EmaFastHandle[i]);
      IndicatorRelease(EmaSlowHandle[i]);
      IndicatorRelease(RsiHandle[i]);
      IndicatorRelease(MacdHandle[i]);
      IndicatorRelease(BbHandle[i]);
      IndicatorRelease(AtrHandle[i]);
   }
   Print("ScalpingEA MT5 Pro deinitialized");
}

//+------------------------------------------------------------------+
//| Reset daily statistics at midnight                                |
//+------------------------------------------------------------------+
void ResetDailyStats()
{
   datetime now = TimeCurrent();
   if(TimeDay(now) != TimeDay(LastResetTime))
   {
      DailyTradeCount = 0;
      LastResetTime = now;
      Print("Daily statistics reset at ", TimeToString(now));
   }
}

//+------------------------------------------------------------------+
//| Check if current time is within trading hours                     |
//+------------------------------------------------------------------+
bool IsWithinTradingHours()
{
   if(!EnableTimeFilter) return(true);
   
   int hour = TimeHour(TimeCurrent());
   if(hour >= StartHour && hour < EndHour) return(true);
   return(false);
}

//+------------------------------------------------------------------+
//| Check daily loss limit                                             |
//+------------------------------------------------------------------+
bool IsWithinDailyLossLimit()
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double dailyLoss = ((balance - equity) / balance) * 100;
   
   if(dailyLoss > MaxDailyLoss)
   {
      PrintFormat("Daily loss limit exceeded: %.2f%% / %.2f%%", dailyLoss, MaxDailyLoss);
      return(false);
   }
   return(true);
}

//+------------------------------------------------------------------+
//| Calculate lot size based on 1% risk and ATR-based SL              |
//+------------------------------------------------------------------+
double CalcLotSize(string symbol, double slPoints)
{
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmt   = balance * (RiskPercent / 100.0);
   double tickVal   = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
   double lotStep   = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
   double minLot    = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
   double maxLot    = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

   if(slPoints <= 0 || tickVal <= 0 || tickSize <= 0) return(minLot);

   double pointVal = tickVal / tickSize * SymbolInfoDouble(symbol, SYMBOL_POINT);
   double lots     = riskAmt / (slPoints * pointVal);

   lots = MathFloor(lots / lotStep) * lotStep;
   return(MathMax(minLot, MathMin(maxLot, lots)));
}

//+------------------------------------------------------------------+
//| Check if spread is acceptable                                     |
//+------------------------------------------------------------------+
bool IsSpreadAcceptable(string symbol)
{
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double spreadPips = (ask - bid) / point;
   
   if(spreadPips > MaxSpreadPips)
   {
      PrintFormat("%s: Spread too wide (%.2f pips)", symbol, spreadPips);
      return(false);
   }
   return(true);
}

//+------------------------------------------------------------------+
//| Check if an open position exists for this symbol                  |
//+------------------------------------------------------------------+
bool HasOpenPosition(string symbol)
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetString(POSITION_SYMBOL) == symbol &&
            PositionGetInteger(POSITION_MAGIC) == (long)MagicNumber)
            return(true);
      }
   }
   return(false);
}

//+------------------------------------------------------------------+
//| Get signal for a given pair index                                 |
//| Returns: 1 = BUY, -1 = SELL, 0 = NO SIGNAL                       |
//+------------------------------------------------------------------+
int GetSignal(int idx)
{
   // Buffer arrays
   double emaFast[3], emaSlow[3], rsiVal[2];
   double macdMain[2], macdSig[2];
   double bbUpper[1], bbMiddle[1], bbLower[1];
   double close[1];

   string sym = Pairs[idx];

   // Copy indicator buffers (shift 1 = last closed candle)
   if(CopyBuffer(EmaFastHandle[idx], 0, 1, 2, emaFast)  < 2) return(0);
   if(CopyBuffer(EmaSlowHandle[idx], 0, 1, 2, emaSlow)  < 2) return(0);
   if(CopyBuffer(RsiHandle[idx],     0, 1, 1, rsiVal)   < 1) return(0);
   if(CopyBuffer(MacdHandle[idx],    0, 1, 2, macdMain) < 2) return(0);
   if(CopyBuffer(MacdHandle[idx],    1, 1, 2, macdSig)  < 2) return(0);
   if(CopyBuffer(BbHandle[idx],      0, 1, 1, bbMiddle) < 1) return(0);  // FIXED: Main/Middle band
   if(CopyBuffer(BbHandle[idx],      1, 1, 1, bbUpper)  < 1) return(0);  // Upper band
   if(CopyBuffer(BbHandle[idx],      2, 1, 1, bbLower)  < 1) return(0);  // Lower band
   if(CopyClose(sym, PERIOD_M5, 1, 1, close)             < 1) return(0);

   // --- EMA crossover (bullish: fast crosses above slow)
   bool emaBullCross = (emaFast[1] <= emaSlow[1]) && (emaFast[0] > emaSlow[0]);
   bool emaBearCross = (emaFast[1] >= emaSlow[1]) && (emaFast[0] < emaSlow[0]);

   // --- RSI signals
   bool rsiBull = (rsiVal[0] < RSI_Oversold);
   bool rsiBear = (rsiVal[0] > RSI_Overbought);

   // --- MACD crossover
   bool macdBull = (macdMain[1] <= macdSig[1]) && (macdMain[0] > macdSig[0]);
   bool macdBear = (macdMain[1] >= macdSig[1]) && (macdMain[0] < macdSig[0]);

   // --- Bollinger Bands (price touching bands)
   bool bbBull = (close[0] <= bbLower[0]);
   bool bbBear = (close[0] >= bbUpper[0]);

   // --- Score (require 3/4 indicators for confirmation)
   int bullScore = (emaBullCross?1:0) + (rsiBull?1:0) + (macdBull?1:0) + (bbBull?1:0);
   int bearScore = (emaBearCross?1:0) + (rsiBear?1:0) + (macdBear?1:0) + (bbBear?1:0);

   if(bullScore >= 3) return(1);
   if(bearScore >= 3) return(-1);
   return(0);
}

//+------------------------------------------------------------------+
//| Open a trade                                                      |
//+------------------------------------------------------------------+
void OpenTrade(int idx, int direction)
{
   string sym    = Pairs[idx];
   double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);
   double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
   double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
   int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);

   // ATR-based SL
   double atrBuf[1];
   if(CopyBuffer(AtrHandle[idx], 0, 1, 1, atrBuf) < 1) return;
   double atr = atrBuf[0];
   double sl  = atr * ATR_Multiplier;
   double tp  = sl * TPRatio;

   double lots = CalcLotSize(sym, sl / point);

   if(lots < SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN))
   {
      PrintFormat("%s: Lot size too small (%.2f)", sym, lots);
      return;
   }

   if(direction == 1)
   {
      double slPrice = NormalizeDouble(ask - sl, digits);
      double tpPrice = NormalizeDouble(ask + tp, digits);
      trade.Buy(lots, sym, ask, slPrice, tpPrice, "Scalp BUY");
   }
   else if(direction == -1)
   {
      double slPrice = NormalizeDouble(bid + sl, digits);
      double tpPrice = NormalizeDouble(bid - tp, digits);
      trade.Sell(lots, sym, bid, slPrice, tpPrice, "Scalp SELL");
   }

   DailyTradeCount++;
   PrintFormat("[TRADE] %s | Dir: %s | Lots: %.2f | SL: %.2f pips | TP: %.2f pips | ATR: %.5f",
               sym, 
               (direction==1)?"BUY":"SELL", 
               lots, 
               sl / point, 
               tp / point,
               atr);
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   ResetDailyStats();

   // Check risk management filters
   if(!IsWithinTradingHours())
   {
      return;
   }

   if(!IsWithinDailyLossLimit())
   {
      return;
   }

   if(DailyTradeCount >= MaxTradesPerDay)
   {
      return;
   }

   for(int i = 0; i < ArraySize(Pairs); i++)
   {
      string sym = Pairs[i];

      // Only process on new M5 bar
      datetime barTime[];
      if(CopyTime(sym, PERIOD_M5, 0, 1, barTime) < 1) continue;
      if(barTime[0] == LastBarTime[i]) continue;
      LastBarTime[i] = barTime[0];

      // Risk management checks
      if(HasOpenPosition(sym)) continue;
      if(!IsSpreadAcceptable(sym)) continue;

      int signal = GetSignal(i);
      if(signal != 0)
         OpenTrade(i, signal);
   }
}
//+------------------------------------------------------------------+