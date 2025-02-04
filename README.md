# effectful

[![Build Status](https://github.com/arybczak/effectful/workflows/Haskell-CI/badge.svg?branch=master)](https://github.com/arybczak/effectful/actions?query=branch%3Amaster)
[![Documentation](https://img.shields.io/static/v1?label=docs&message=effectful-core-0.1&color=informational)](https://rybczak.net/files/effectful/effectful-core-0.1-docs)
[![Documentation](https://img.shields.io/static/v1?label=docs&message=effectful-0.1&color=informational)](https://rybczak.net/files/effectful/effectful-0.1-docs)

<img src="https://user-images.githubusercontent.com/387658/127747903-f728437f-2ee4-47b8-9f0c-5102fd44c8e4.png" width="128">

*Note:* this is a pre-release of the 0.1 version. Please disregard the 0.0.0.0
version available on Hackage as the API has been completely redesigned since
then.

An easy to use, performant extensible effects library with seamless integration
with the existing Haskell ecosystem.

Main features:

1. Very fast (benchmark results with GHC 8.8.4:
   [countdown](https://rybczak.net/files/effectful/countdown.html),
   [filesize](https://rybczak.net/files/effectful/filesize.html), [comparison
   with eff](https://rybczak.net/files/effectful/eff_comparison.html)).

2. Easy to use API (no boilerplate code and dealing with arcane types).

3. Correct semantics in presence of runtime exceptions (no more discarded state
   updates).

4. Seamless integration with the existing ecosystem (`exceptions`,
   `monad-control`, `unliftio-core`, `resourcet` etc.).

5. Support for thread local and shared state.

6. Support for statically and dynamically dispatched effects.

## Motivation

Do we really need yet another library for handling effects? There's
[freer-simple](https://hackage.haskell.org/package/freer-simple),
[fused-effects](https://hackage.haskell.org/package/fused-effects),
[polysemy](https://hackage.haskell.org/package/polysemy),
[eff](https://github.com/hasura/eff) and probably a few more.

Unfortunately, of all of them only `eff` is a promising proposition because of
reasonable performance characteristics (see the talk "Effects for Less" linked
below for more information) and potential for good interoperability with the
existing ecosystem.

The second point is arguably the most important, because it allows focusing on
things that matter instead of reinventing all kinds of wheels, hence being a
necessary condition for broader adoption of the library.

However, `eff` uses delimited continuations underneath, which:

- Are not yet supported by GHC (though [the
proposal](https://github.com/ghc-proposals/ghc-proposals/pull/313) for including
support for them has been accepted).

- Are quite hard to understand.

- Make the library "too powerful" in a sense as it faces
  [a](https://github.com/hasura/eff/issues/13)
  [few](https://github.com/hasura/eff/issues/7)
  [issues](https://github.com/hasura/eff/issues/12) with no clear path towards
  their resolution.

On the other hand, if support for continuations is excluded from the handler
monad, then the ability to define effects with non-linear control flow (such as
`NonDet`) is lost. Arguably it's a small price to pay for predictability,
because such specialized effects are needed rarely and locally, at which point a
dedicated, well established solution such as
[conduit](https://hackage.haskell.org/package/conduit) or
[list-t](https://hackage.haskell.org/package/list-t) can be used.

This is where `effectful` comes in. The `Eff` monad it uses is essentially a
`ReaderT` over `IO` on steroids, allowing us to dynamically extend its
environment with data types that represent effects or their handlers.

Because this concept is so simple:

- It's reasonably easy to understand what is going on under the hood.

- The `Eff` monad being a reader allows for seamless interoperability with
  ubiquitous classes such as `MonadBaseControl` and `MonadUnliftIO` as well as
  support for handling runtime exceptions without worrying about discarded state
  updates (see the talk "Monad Transformer State" linked below for more
  information).

What is more:

- The `Eff` monad is concrete, so GHC has many possibilities for optimization,
  which results in a very fast code at a default optimization level. There is no
  need to mark every function `INLINE` or enable additional optimization passes,
  it just works.

- If an advanced capability with non-linear control flow is needed, you can
  always stick a transformer that implements it on top of `Eff` in a local
  context.

In conclusion, `effectful` aims to reduce duplication and bring back performance
to "boring" transformer stacks, most of which are a dozen of newtype'd `StateT`
or `ReaderT` transformers, each with a few associated operations (usually tied
to a type class), not to replace monad transformers altogether.

## Usage

The effect system and its effects are split among several libraries:

- The `effectful-core` library contains the main machinery of the effect system
  itself and basic effects. It aims for a small dependency footprint and
  provides building blocks for more advanced effects.

- The `effectful` library re-exports public modules of `effectful-core` and in
  addition provides functionality of the `unliftio` package divided into
  appropriate effects.

## Example

A `Filesystem` effect with two handlers, one that runs in `IO` and another that
uses an in-memory virtual file system can be found
[here](https://github.com/arybczak/effectful/blob/master/effectful/examples/FileSystem.hs).

## Resources

Resources that inspired the rise of this library and had a lot of impact on its
design.

Talks:

* [Effects for Less](https://www.youtube.com/watch?v=0jI-AlWEwYI) by Alexis King.

* [Monad Transformer State](https://www.youtube.com/watch?v=KZIN9f9rI34) by Michael Snoyman.

Blog posts:

* [ReaderT design pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern/) by Michael Snoyman.

* [Exceptions Best Practices](https://www.fpcomplete.com/blog/2016/11/exceptions-best-practices-haskell/) by Michael Snoyman.

----------------------------------------

<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
