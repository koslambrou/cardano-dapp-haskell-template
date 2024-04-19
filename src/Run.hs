{-# LANGUAGE OverloadedStrings     #-}

module Run
  ( run
  ) where

import AuctionValidator (auctionValidatorScript, AuctionParams(AuctionParams, apSeller, apAsset, apMinBid, apEndTime))
import Data.ByteString qualified as B
import Data.ByteString.Base16 qualified as Base16
import Data.ByteString.Short qualified as B
import PlutusLedgerApi.V2 qualified as V2
import Prelude qualified as Hs
import Prelude (($), (.))

run :: Hs.IO ()
run = B.writeFile "validator.uplc" . Base16.encode $ B.fromShort serialisedScript
  where
    serialisedScript = V2.serialiseCompiledCode script
    script = auctionValidatorScript params
    params =
      AuctionParams
        { apSeller = V2.PubKeyHash "58208581baf3dd0ac09b3e844b18b7eed158f6f2ddd9a38f4f22b5264bde51a295af"
        , -- The asset to be auctioned is 10000 lovelaces
          apAsset = V2.singleton V2.adaSymbol V2.adaToken 10000
        , -- The minimum bid is 100 lovelaces
          apMinBid = 100
        , apEndTime = V2.POSIXTime 0
        }
