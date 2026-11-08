const express = require("express");
const axios = require("axios");
const cors = require("cors");

require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

//just test our BE
app.get("/", (req, res) => {
  res.send(" CryptoCoin App Backend is running");
});

//get crypto coin  data
app.get("/api/coins", async (req, res) => {
  try {
const currency = (req.query.currency || "usd").toLowerCase();
    const response = await axios.get(
      "https://api.coingecko.com/api/v3/coins/markets",
      {
        params: {
          vs_currency: currency,
          order: "market_cap_desc",
          per_page: 50,
          page: 1,
          sparkline: false,
        },
        headers: process.env.COINGECKO_API_KEY
          ? {
            "x-cg-demo-api-key": process.env.COINGECKO_API_KEY,
          }
          : {},
      },
    );

    res.status(200).json(response.data);

  } catch (e) {
    console.error(
      "CoinGecko error:",
      e.response?.status,
      e.response?.data || e.message
    );

    res.status(e.response?.status == 500).json({
      'message': "unable to fetch coinlist!"
    })
  }
});

// Get  currencies
app.get("/api/currencies", async (req, res) => {
  try {
    const response = await axios.get(
      `https://api.coingecko.com/api/v3/simple/supported_vs_currencies`,
      {
        headers: process.env.COINGECKO_API_KEY
          ? {
            "x-cg-demo-api-key": process.env.COINGECKO_API_KEY,
          }
          : {},
      }
    );

    res.status(200).json(response.data);

  } catch (e) {
    console.error(
      "Currency API error:",
      e.response?.status,
      e.response?.data || e.message
    );

    res.status(e.response?.status || 500).json({
      message: "Unable to fetch supported currencies",
    });
  }
});


//get coin details information
app.get("/api/coins/:id", async (req, res) => {
  try {
    const coinId = req.params.id;

    const response = await axios.get(`https://api.coingecko.com/api/v3/coins/${coinId}`,
      {
        params: {
          // currency:"usd",
          localization: false,
          tickers: false,
          market_data: true,
          community_data: false,
          developer_data: false,
          sparkline: false,
        },
        headers:  process.env.COINGECKO_API_KEY ?
          {"x-cg-demo-api-key": process.env.COINGECKO_API_KEY}
           : {}
      }
    );
    res.status(200).json((response).data)

  } catch (e) {
    console.error(
      "Coin Details API error:",
      e.response?.status,
      e.response?.data || e.message
    );

    res.status(e.response?.status || 500).json({
      message: "Unable to fetch coin details",
    });
  }
});


// Get coin historical chart data
app.get("/api/coins/:id/chart", async (req, res) => {
  try {
    const coinId = req.params.id;
    const currency = (req.query.currency || "usd").toLowerCase();
    const days = req.query.days || "7";

    const response = await axios.get(
      `https://api.coingecko.com/api/v3/coins/${coinId}/market_chart`,
      {
        params: {
          vs_currency: currency,
          days: days,
        },
        headers: process.env.COINGECKO_API_KEY
          ? {
              "x-cg-demo-api-key": process.env.COINGECKO_API_KEY,
            }
          : {},
      }
    );

    res.status(200).json(response.data);

  } catch (e) {
    console.error(
      "Coin Chart API error:",
      e.response?.status,
      e.response?.data || e.message
    );

    res.status(e.response?.status || 500).json({
      message: "Unable to fetch coin chart data",
    });
  }
});

//market stat
app.get("/api/market-stats", async (req, res) => {
   console.log("Market Stats API called");

  try{
  

  const response = await axios.get(`https://api.coingecko.com/api/v3/global`,
  {
     headers:  process.env.COINGECKO_API_KEY ?
          {"x-cg-demo-api-key": process.env.COINGECKO_API_KEY}
           : {}
  }
  );
    
    res.status(200).json(response.data.data);

  }catch(e)
  {
     console.error(
      "Coin Details API error:",
      e.response?.status,
      e.response?.data || e.message
    );

    res.status(e.response?.status || 500).json({
      message: "Unable to fetch globalmarket details",
    });
  }
});
//market stat filter currency
app.get("/api/market-stats/currency", async (req, res) => {
  try{
   console.log("Market Stats API called");
const currency = (req.query.currency || "usd").toLowerCase();
  const response = await axios.get(`https://api.coingecko.com/api/v3/global`,
    {
       headers:  process.env.COINGECKO_API_KEY ?
          {"x-cg-demo-api-key": process.env.COINGECKO_API_KEY}
           : {}
    }
  
  );
     const globalData = response.data.data;

    const marketCap = globalData.total_market_cap[currency];
    const totalVolume = globalData.total_volume[currency];

    if (marketCap == null || totalVolume == null) { //if cur null
      return res.status(400).json({
        message: "Unsupported currency",
      });
    }

    res.json({
      currency: currency,
      totalMarketCap: marketCap,
      totalVolume: totalVolume,
      bitcoinDominance: globalData.market_cap_percentage.btc,
      ethereumDominance: globalData.market_cap_percentage.eth,
      activeCryptocurrencies: globalData.active_cryptocurrencies,
      marketCapChangePercentage24hUsd:
          globalData.market_cap_change_percentage_24h_usd,
    });

  }catch(e)
  {
     console.error(
      "Coin Details API error:",
      e.response?.status,
      e.response?.data || e.message
    );

    res.status(e.response?.status || 500).json({
      message: "Unable to fetch globalmarket details",
    });
  }
});


console.log(
  'Check API Key loaded:',
  Boolean(process.env.COINGECKO_API_KEY)
);

//start bE
app.listen(PORT, "0.0.0.0", () => {
  console.log(`CryptoCoin backend running on http://localhost:${PORT}`);
});
