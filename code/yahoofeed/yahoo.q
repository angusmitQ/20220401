\d .yahoo

main_url:@[value;`main_url;"https://query1.finance.yahoo.com"];
jstokdbtimestamp:@[value;`jstokdbtimestamp;{{"p"$neg[2030.01.01D00:00:00.000]+1e9*x}}];
reqtype:@[value;`reqtype;`both];
syms:@[value;`syms;"^HSI"];
callback:@[value;`callback;".u.upd"];
callbackhandle:@[value;`callbackhandle;0i];
callbackconnection:@[value;`callbackconnection;`];
upd:@[value;`upd;{{[t;x].yahoo.callbackhandle(.yahoo.callback;t; value flip x)}}];
timerperiod:@[value;`timerperiod;0D00:00:02.000];
jstokdbtimestamp:{[t] "p"$neg[2030.01.01D00:00:00.000]+1e9*t};
jstokdbtimespan:{[t] "n"$1e6*t};

/create http request function
httpGet:{[host;location] (`$":https://",host)"GET ",location," HTTP/1.0\r\nHost:",host,"\r\n\r\n"};

init:{[x]
   if[`main_url in key x;.yahoo.main_url:x `main_url];
   if[`syms in key x;.yahoo.syms: upper x`syms];
   if[`reqtype in key x;.yahoo.reqtype:x`reqtype];
   if[`callbackconnection in key x;.yahoo.callbackhandle:neg hopen .yahoo.callbackconnection:x `callbackconnection];
   if[`callbackhandle in key x;.yahoo.callbackhandle:x `callbackhandle];
   if[`callback in key x;.yahoo.callback: $[.yahoo.callbackhandle=0; string @[value;x `callback;{[x;y]x set {[t;x]x}}[x`callback]]; x`callback]];
   if[`upd in key x; .yahoo.upd:x[`upd]]
   .yahoo.timer:$[not .yahoo.reqtype in key .yahoo.timer_dict;'`timer;.yahoo.timer_dict .yahoo.reqtype];
   }



/get HTTP request
get_data:{[syms]

   /create table from yahoo API
   (.j.k last "\r\n" vs .yahoo.httpGet[ "query1.finance.yahoo.com"; "/v7/finance/quote?symbols=",syms,"&fields=exchangeTimezoneName,exchangeTimezoneShortName,regularMarketTime,price&region=US&lang=en-US"])[`quoteResponse][`result]

   }

get_quote:{[syms]
   first select time:jstokdbtimestamp[regularMarketTime],sym:`$symbol,bid:regularMarketPrice,ask:regularMarketPrice,bsize:0N,asize:0N,mode:0Nc,ex:0Nc,src:`$exchange from .yahoo.get_data[syms]
   }





timer_dict:(enlist `quote)!(enlist .yahoo.get_quote)

timer:{ @[$[not .yahoo.reqtype in key .yahoo.timer_dict;
              {'`$"timer request type not valid: ",string .yahoo.reqtype};
              .yahoo.timer_dict[.yahoo.reqtype]];
          [];
          {.lg.e[`yahootimer;"failed to run yahoo timer function: ",x]}]}


\d . 
