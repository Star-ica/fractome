// Hardcoded contract address — update after deploy.
// Edit address to point this front end at an existing deployment.
window.APP_CONFIG = {
  "address": "0x0000000000000000000000000000000000000000",
  "slug": "fractionhome",
  "name": "FractionHome",
  "accent": "#a63d5a",
  "tagline": "Own a slice of a property and collect your share of the rent.",
  "about": "One property split into shares. Buy shares with the stablecoin; when the owner deposits rent, every shareholder can claim their pro-rata part.",
  "tokens": [
    "payToken"
  ],
  "deploy": {
    "tokens": [
      {
        "name": "Mock USD",
        "symbol": "mUSD"
      }
    ],
    "args": [
      "$t0",
      "Lekki Residence, Unit A",
      1000,
      "10000000000000000000"
    ]
  },
  "stats": [
    {
      "label": "Property",
      "fn": "propertyName",
      "fmt": "raw"
    },
    {
      "label": "Total shares",
      "fn": "totalShares",
      "fmt": "raw"
    },
    {
      "label": "Shares sold",
      "fn": "sold",
      "fmt": "raw"
    },
    {
      "label": "Price per share",
      "fn": "pricePerShare",
      "fmt": "token"
    },
    {
      "label": "Your shares",
      "fn": "shares",
      "fmt": "raw",
      "args": [
        "me"
      ]
    },
    {
      "label": "Your pending rent",
      "fn": "pendingRent",
      "fmt": "token",
      "args": [
        "me"
      ]
    }
  ],
  "actions": [
    {
      "title": "Buy shares",
      "fn": "buyShares",
      "inputs": [
        {
          "id": "count",
          "label": "Number of shares",
          "type": "uint",
          "default": "10"
        }
      ]
    },
    {
      "title": "Claim rent",
      "fn": "claimRent",
      "inputs": []
    },
    {
      "title": "Transfer shares",
      "fn": "transferShares",
      "inputs": [
        {
          "id": "to",
          "label": "Recipient",
          "type": "address",
          "meDefault": false
        },
        {
          "id": "count",
          "label": "Number of shares",
          "type": "uint",
          "default": "1"
        }
      ]
    },
    {
      "title": "Deposit rent (owner)",
      "fn": "depositRent",
      "inputs": [
        {
          "id": "amount",
          "label": "Amount",
          "type": "amount",
          "default": "400"
        }
      ]
    },
    {
      "title": "Withdraw sale proceeds (owner)",
      "fn": "withdrawProceeds",
      "inputs": []
    }
  ],
  "views": [
    {
      "title": "Pending rent of an address",
      "fn": "pendingRent",
      "inputs": [
        {
          "id": "a",
          "label": "Address",
          "type": "address",
          "meDefault": true
        }
      ]
    }
  ]
};
