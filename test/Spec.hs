{-# LANGUAGE NamedFieldPuns #-}

module Spec where

import Cardano.Api qualified as C
import Cardano.Testnet (Conf (Conf), TmpAbsolutePath (TmpAbsolutePath))
import Cardano.Testnet qualified as Testnet
import Hedgehog qualified as H
import Hedgehog.Extras qualified as H
import System.FilePath ((</>))
import System.Info qualified as SysInfo
import Testnet.Property.Utils qualified as H
import Testnet.Runtime (TestnetRuntime (TestnetRuntime), poolNodes, testnetMagic)

hprop_testnetProperty :: H.Property
hprop_testnetProperty = H.integrationRetryWorkspace 2 "conway-stake-snapshot" $ \tempAbsBasePath' -> do
  H.note_ SysInfo.os
  conf@Conf {Testnet.tempAbsPath} <- H.noteShowM $ Testnet.mkConf tempAbsBasePath'
  let tempAbsPath' = Testnet.unTmpAbsPath tempAbsPath
  work <- H.createDirectoryIfMissing $ tempAbsPath' </> "work"

  let tempBaseAbsPath = Testnet.makeTmpBaseAbsPath $ TmpAbsolutePath tempAbsPath'
      era = C.BabbageEra
      options =
        Testnet.cardanoDefaultTestnetOptions
          { Testnet.cardanoNodes = Testnet.cardanoDefaultTestnetNodeOptions,
            Testnet.cardanoEpochLength = 1000,
            Testnet.cardanoSlotLength = 0.02,
            Testnet.cardanoNodeEra = C.AnyCardanoEra era
          }

  TestnetRuntime
    { testnetMagic,
      poolNodes
    } <-
    Testnet.cardanoTestnet options conf

  H.assert True
