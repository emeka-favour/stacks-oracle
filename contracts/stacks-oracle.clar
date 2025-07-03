;; Title: StacksOracle Protocol
;; Summary: Advanced Bitcoin Price Forecasting Markets on Stacks Blockchain
;; Description: A next-generation decentralized protocol enabling sophisticated
;;              Bitcoin price prediction markets built on Stacks Layer 2. Users
;;              can participate in trustless forecasting by staking STX tokens
;;              on directional Bitcoin price movements. The protocol implements
;;              oracle-verified price settlements, dynamic reward pools, and
;;              transparent market resolution mechanisms. Designed for maximum
;;              capital efficiency with automated fee distribution and robust
;;              security guarantees inherited from Bitcoin's base layer.

;; PROTOCOL CONSTANTS & ERROR DEFINITIONS

;; Contract Governance
(define-constant PROTOCOL_ADMIN tx-sender)

;; Comprehensive Error Code System
(define-constant ERR-UNAUTHORIZED-ACCESS (err u100)) ;; Access control violation
(define-constant ERR-RESOURCE-NOT-FOUND (err u101)) ;; Missing market/prediction data
(define-constant ERR-INVALID-FORECAST (err u102)) ;; Malformed prediction parameters
(define-constant ERR-MARKET-INACTIVE (err u103)) ;; Market outside active window
(define-constant ERR-REWARD-CLAIMED (err u104)) ;; Duplicate payout attempt
(define-constant ERR-INSUFFICIENT-FUNDS (err u105)) ;; Inadequate STX balance
(define-constant ERR-INVALID-INPUT (err u106)) ;; Parameter validation failure

;; PROTOCOL STATE MANAGEMENT

;; Oracle Integration Settings
(define-data-var price-oracle-endpoint principal 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; Market Economics Configuration
(define-data-var min-participation-threshold uint u1000000) ;; 1 STX minimum (uSTX)
(define-data-var protocol-fee-rate uint u2) ;; 2% fee on rewards
(define-data-var global-market-index uint u0) ;; Market ID generator

;; CORE DATA STRUCTURES

;; Prediction Market Schema
;; Stores comprehensive market state including price points, stakes, and timing
(define-map prediction-markets
  uint ;; Market identifier
  {
    initial-btc-price: uint, ;; Opening Bitcoin price snapshot
    final-btc-price: uint, ;; Settlement price (post-resolution)
    bullish-pool: uint, ;; Total STX staked on price increase
    bearish-pool: uint, ;; Total STX staked on price decrease
    market-open-height: uint, ;; Block height when market opens
    market-close-height: uint, ;; Block height when market closes
    is-resolved: bool, ;; Market settlement status
  }
)

;; Participant Position Registry
;; Tracks individual user positions across prediction markets
(define-map participant-positions
  {
    market-id: uint, ;; Associated market identifier
    participant: principal, ;; User wallet address
  }
  {
    price-direction: (string-ascii 4), ;; Forecast: "bull" or "bear"
    staked-amount: uint, ;; STX tokens committed
    rewards-claimed: bool, ;; Payout status tracker
  }
)

;; PRIMARY PROTOCOL FUNCTIONS

;; Initialize New Prediction Market
;; Creates a new Bitcoin price forecasting market with specified parameters
(define-public (initialize-prediction-market
    (btc-price uint)
    (open-height uint)
    (close-height uint)
  )
  (let ((new-market-id (var-get global-market-index)))
    ;; Administrative access validation
    (asserts! (is-eq tx-sender PROTOCOL_ADMIN) ERR-UNAUTHORIZED-ACCESS)
    ;; Input parameter validation
    (asserts! (> close-height open-height) ERR-INVALID-INPUT)
    (asserts! (> btc-price u0) ERR-INVALID-INPUT)
    ;; Market initialization with default state
    (map-set prediction-markets new-market-id {
      initial-btc-price: btc-price,
      final-btc-price: u0,
      bullish-pool: u0,
      bearish-pool: u0,
      market-open-height: open-height,
      market-close-height: close-height,
      is-resolved: false,
    })
    ;; Increment global market counter
    (var-set global-market-index (+ new-market-id u1))
    (ok new-market-id)
  )
)