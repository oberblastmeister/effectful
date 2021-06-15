{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_HADDOCK not-home #-}
-- | Type-safe indexing for 'Effectful.Internal.Monad.Env'.
--
-- This module is intended for internal use only, and may change without warning
-- in subsequent releases.
module Effectful.Internal.Effect
  ( Effect
  , (:>)(..)
  , IdE(..)
  ) where

import Data.Kind

type Effect = (Type -> Type) -> Type -> Type

-- | Adapter for statically dispatched effects.
newtype IdE (e :: Effect) where
  IdE :: (forall m r. e m r) -> IdE e

class (e :: Effect) :> (es :: [Effect]) where
  -- | Get position of @e@ in @es@.
  --
  -- /Note:/ GHC is kind enough to cache these values as they're top level CAFs,
  -- so the lookup is amortized @O(1)@ without any language level tricks.
  reifyIndex :: Int
  reifyIndex = -- Don't show "minimal complete definition" in haddock.
               error "unimplemented"

instance {-# OVERLAPPING #-} e :> (e : es) where
  reifyIndex = 0

instance e :> es => e :> (x : es) where
  reifyIndex = 1 + reifyIndex @e @es