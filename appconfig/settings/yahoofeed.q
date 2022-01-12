// Bespoke Feed config : Finance Starter Pack

\d .proc
loadprocesscode:1b

\d .servers
enabled:1b
CONNECTIONS:enlist `segmentedtickerplant       // Feedhandler connects to the tickerplant
HOPENTIMEOUT:30000

\d .yahoo
main_url:"https://query1.finance.yahoo.com"
jstokdbtimestamp:{[t] "p"$neg[2030.01.01D00:00:00.000]+1e9*t}
jstokdbtimespan:{[t] "n"$1e6*t}
reqtype:`both
syms:"^HSI"
callback:".u.upd"
upd:{[t;x] .yahoo.callbackhandle(.yahoo.callback;t; value flip delete time from x)}
timerperiod:0D00:00:02.000
\d .
~

