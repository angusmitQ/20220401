yahoo:{[syms]
 
/create http request function
 httpGet:{[host;location] (`$":https://",host)"GET ",location," HTTP/1.0\r\nHost:",host,"\r\n\r\n"};
 
/create table from yahoo API
 (.j.k last "\r\n" vs httpGet[ "query1.finance.yahoo.com"; "/v7/finance/quote?symbols=",syms,"&fields=exchangeTimezoneName,exchangeTimezoneShortName,regularMarketTime,price&region=US&lang=en-US"])[`quoteResponse][`result]

 }
