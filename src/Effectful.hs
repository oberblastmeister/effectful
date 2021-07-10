module Effectful
  ( -- * The 'Eff' monad
    Eff

  -- ** Effect constraints
  , Effect
  , (:>)

  -- ** Sending effects
  , send

  -- * Running the 'Eff' monad

  -- ** Pure operations
  , runEff

  -- ** Operations with side effects
  , IOE
  , runIOE

  -- *** Unlift strategies
  , UnliftStrategy(..)
  , Persistence(..)
  , Limit(..)
  , unliftStrategy
  , withUnliftStrategy

  -- * Building 'Effect' handlers

  -- ** Basic handlers
  , interpret
  , interpretM

  -- ** Derived handlers
  , reinterpret
  , reinterpretM

  -- ** Local operations
  , LocalEnv

  -- *** 'Eff'
  , localSeqUnlift
  , localUnlift

  -- *** 'IO'
  , localSeqUnliftIO
  , localUnliftIO
  , localLiftUnliftIO
  , withLiftSeqOp
  ) where

import Effectful.Interpreter
import Effectful.Monad