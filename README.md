# StacksOracle Protocol

> Advanced Bitcoin Price Forecasting Markets on Stacks Blockchain

A next-generation decentralized protocol enabling sophisticated Bitcoin price prediction markets built on Stacks Layer 2. StacksOracle allows users to participate in trustless forecasting by staking STX tokens on directional Bitcoin price movements, with oracle-verified settlements and transparent reward distribution.

## 🎯 Overview

StacksOracle Protocol transforms Bitcoin price speculation into a structured, transparent prediction market ecosystem. By leveraging Stacks' unique positioning as Bitcoin's Layer 2, the protocol inherits Bitcoin's security guarantees while enabling fast, low-cost prediction market operations.

### Key Features

- **Trustless Prediction Markets**: No intermediaries required for market creation or settlement
- **Oracle-Verified Settlements**: Reliable Bitcoin price feeds ensure accurate market resolution  
- **Proportional Reward Distribution**: Winners receive payouts proportional to their stake and risk
- **Dynamic Market Creation**: Flexible timeframes and price points for diverse trading strategies
- **Built-in Fee Management**: Transparent protocol fee structure with admin controls
- **Stacks Native**: Optimized for STX token economics and Bitcoin Layer 2 infrastructure

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    StacksOracle Protocol                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌──────────────┐ │
│  │   Participants  │    │   Oracle Feed   │    │    Admin     │ │
│  │                 │    │                 │    │              │ │
│  │ • Submit Bets   │    │ • Price Data    │    │ • Create     │ │
│  │ • Claim Rewards │    │ • Settlement    │    │   Markets    │ │
│  │ • View Markets  │    │ • Validation    │    │ • Configure  │ │
│  └─────────────────┘    └─────────────────┘    └──────────────┘ │
│           │                       │                     │       │
│           └───────────────┬───────────────┬─────────────┘       │
│                           │               │                     │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                Contract Core Logic                          │ │
│  ├─────────────────────────────────────────────────────────────┤ │
│  │                                                             │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │ │
│  │  │   Market    │  │ Participant │  │   Reward & Fee      │  │ │
│  │  │ Management  │  │ Positions   │  │   Distribution      │  │ │
│  │  │             │  │             │  │                     │  │ │
│  │  │ • Creation  │  │ • Tracking  │  │ • Calculation       │  │ │
│  │  │ • Timing    │  │ • Stakes    │  │ • Proportional      │  │ │
│  │  │ • Settlement│  │ • Claims    │  │ • Fee Collection    │  │ │
│  │  └─────────────┘  └─────────────┘  └─────────────────────┘  │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                    Stacks Blockchain Layer                      │
│                   • STX Token Management                        │
│                   • Smart Contract Execution                    │
│                   • Transaction Settlement                      │
└─────────────────────────────────────────────────────────────────┘
```

## 🔧 Contract Architecture

### Core Components

#### **State Management**

- **Oracle Integration**: Manages authorized price feed endpoints
- **Market Economics**: Configurable parameters for participation and fees
- **Global Indexing**: Unique market identification and tracking

#### **Data Structures**

**Prediction Markets Map**

```clarity
{
    initial-btc-price: uint,      // Market opening price
    final-btc-price: uint,        // Settlement price  
    bullish-pool: uint,           // Total STX on price increase
    bearish-pool: uint,           // Total STX on price decrease
    market-open-height: uint,     // Trading start block
    market-close-height: uint,    // Trading end block
    is-resolved: bool             // Settlement status
}
```

**Participant Positions Map**

```clarity
{
    price-direction: string,      // "bull" or "bear" forecast
    staked-amount: uint,          // STX tokens committed
    rewards-claimed: bool         // Payout status
}
```

#### **Function Categories**

**Market Operations**

- `initialize-prediction-market`: Create new forecasting markets
- `submit-forecast`: Stake STX on price direction predictions
- `settle-market-outcome`: Oracle-authorized price settlement
- `claim-forecast-rewards`: Proportional payout distribution

**Data Access**

- `get-market-data`: Retrieve complete market information
- `get-participant-position`: Access user position details
- `get-protocol-treasury`: Query contract STX balance
- `get-protocol-settings`: View configuration parameters

**Administration**

- `update-oracle-endpoint`: Modify authorized price feed
- `adjust-min-stake`: Set minimum participation threshold
- `modify-fee-rate`: Update protocol fee percentage
- `withdraw-protocol-fees`: Extract accumulated fees

## 🔄 Data Flow

### Market Lifecycle

```
1. MARKET CREATION
   Admin → initialize-prediction-market() → New Market ID

2. PREDICTION PHASE
   Users → submit-forecast() → STX Transfer → Position Recorded
   
3. MARKET SETTLEMENT
   Oracle → settle-market-outcome() → Final Price Set
   
4. REWARD DISTRIBUTION  
   Winners → claim-forecast-rewards() → Proportional Payout
```

### Reward Calculation Logic

```
Total Pool = Bullish Pool + Bearish Pool
Winning Pool = Pool matching actual price direction
User Reward = (User Stake × Total Pool) ÷ Winning Pool
Protocol Fee = User Reward × Fee Rate
Net Payout = User Reward - Protocol Fee
```

## 🚀 Usage Examples

### Creating a Market (Admin Only)

```clarity
(initialize-prediction-market 
    u50000000000    ;; $50,000 initial BTC price
    u1000           ;; Open at block 1000
    u2000)          ;; Close at block 2000
```

### Submitting a Bullish Forecast

```clarity
(submit-forecast 
    u0              ;; Market ID 0
    "bull"          ;; Price increase prediction
    u5000000)       ;; 5 STX stake
```

### Claiming Rewards (Post-Settlement)

```clarity
(claim-forecast-rewards u0)  ;; Claim from Market ID 0
```

## ⚙️ Configuration Parameters

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| Minimum Stake | 1,000,000 µSTX | 1 STX minimum participation |
| Protocol Fee | 2% | Fee on winning payouts |
| Oracle Address | Configurable | Authorized price feed source |

## 🔐 Security Features

- **Access Control**: Admin-only functions for critical operations
- **Input Validation**: Comprehensive parameter checking
- **Double-Spend Protection**: Claim status tracking prevents duplicate payouts
- **Market Timing**: Strict enforcement of trading windows
- **Oracle Authorization**: Only designated oracle can settle markets

## 🛠️ Development & Deployment

### Prerequisites

- Stacks CLI tools
- Clarity smart contract development environment
- STX tokens for testing and deployment

### Testing

Run comprehensive tests covering:

- Market creation and validation
- Prediction submission edge cases  
- Settlement accuracy and timing
- Reward calculation precision
- Administrative function security

## 📄 License

This protocol is released under MIT License. See LICENSE file for details.

## 🤝 Contributing

Contributions welcome! Please review our contributing guidelines and submit pull requests for review.
