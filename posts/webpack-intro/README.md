---
title: 'Webpack에 관해'
date: 2021-01-22T06:01:46.368Z
---
# Webpack에 관해

1. 역사와 다른 번들러와의 비교, webpack의 정체성과 주요 컨셉


2. 사용법

3. 어드벤스드
  - write your own module
  - code splitting
  - module federation
    - micro fe

bundler enables modular programming

> webpack: a completely event-driven plugin-based compiler

목차
- walk through the source...
- what is plug-in?
- its power

## Walk through the source
80% of the source code is plugin..

### What is **Tapable**?
- ~200 line plugin library
- the backbone of the plugin system
- without it, webpack is nothing.. 

#### Tapable instance
> : A class/object that extend Tapable (aka sth you can plug into)

- Compilation
  - Created by the compiler
  - Contains dep graph traversal algo.

- Resolver
  - path finder...
  - 이런이런 파일이 있어? 있으면 이런 정보를 가져다 줘 를 할 수 있게 함.

- Module Factories
  - Takes Succesfully Resolved Requests
  - Collects source for that file. Creates a Module obj.

- Parsers
  - Parses!
  - Takes a Module Object, turns into AST to parse
  - Find all require or imports, create Depndency's!

- Template
  - Data binding for your modules
  - Creates the code you see in your bundles

---
> Plugins are the backbone of webpack.
> webpack itself is built on the same plugin system that you use in your webpack configuration!
> They also serve the purpose of doing anything else that a loader cannot do.  [^webpack-doc-plugin]

A webpack plugin
: A JavaScript object that has an `apply` method.

Usage
  - Configuration
  - Node API: extremely similar to the webpack runtime itself.


---



## 웹팩 플러그인 만들어보자!

## Why Do We Care about Plugins?

어떻게 플러그인을 만드는지 알면,
웹팩이 어떻게 작동하는지 알게 된다.


[^webpack-doc-plugin]: https://webpack.js.org/concepts/plugins/


- esbuild 로더가 있다.
- 


----

[Advanced Webpack](https://www.youtube.com/watch?v=MzVFrIAwwS8)




