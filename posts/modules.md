---
title: CommonJS 모듈과 package.json
date: 2019-06-05T02:26:58.435Z
---

모듈에 대해 정확히 이해해야 프로젝트를 하는데 용이할 것 
같아 기본적인 내용을 공부하며 정리하고자 한다. 
Javascript 언어 자체에서 모듈을 지원하기 시작한 것은
ECMAScript 6가 처음이다. 
ECMAScript 5까지는 모듈 기능을 구현한 라이브러리를 
이용해왔다. 이 라이브러리들을 나름의 스탠다드를
구현하고 있는데,
개중에 중요한 2개는 Node.js의 코어모듈로 구현돼있는
CommonJS와 Require.js로 구현돼있는 AMD라고 한다. 

| 스탠다드  |  키워드  |
| ------------ |  ------------------- |
| CommonJS |  `require()`, `module.exports` |
| AMD ~Async\ Module\ Definition~| `require()`, `define()`|
| UMD ~Univeral\ Module\ Definition~ | 즉시실행함수와 `this` 활용 | 
| ES6 | `import`, `export` | 
[JS 모듈 스탠다드 종류][js_module_standard_types]

<br />

ECMA6의 모듈 스펙은 노드에서는 8.5.0버전에서부터 
일찍이 구현되어있지만, IE와 Samsung Internet 에서는
지원하지 않고 있다.[^ECMA6\_Modules]
나는 NPM과 Node에 익숙해지고 싶은 것이니,
우선은 CommonJS 위주로 정리를 했다.
거기에 package.json에 대해서도 간단히 조사했다.

## CommonJS
Node.js 공식 API 레퍼런스 문서에서 Modules란에 가면
CommonJS 모듈에 대한 설명이 나온다.
Node.js 에서 자체적으로 CommonJS 스탠다드를 구현해
코어 모듈로 사용해왔기 때문이다.
깃허브에서 보면 다음과 같다.
깃헙 레파지토리에서 module 코어 모듈을 들춰보면 다음과 같다.
```js
// node/lib/module.js
'use strict';
module.exports = require('internal/modules/cjs/loader').Module;
```
`internal/modules/`에 가면 CommonJS를 뜻하는 cjs말고도 
ECMAScript Module을 구현한 esm도 있다. 
아직 cjs를 기본 로더로 사용하고 있는 모습이 인상적이다.
  

### 어떤 것이 모듈로 취급되는가
각 파일은 하나의 모듈로 취급된다. 
이는 ECMAScript 모듈에서도 변하지 않는다.
모듈의 크기가 커지면 폴더를 만들어
모듈을 구성하게 되는데,
폴더를 require의 인자로 넘기는 방법은 3가지가 있다.
1. 최상위 폴더의 `package.json`에 `main` 프로퍼티를 명시한다. <br />
Node에게 엔트리 포인트를 알려주는 것이다.

2. 폴더 안에 `index.js`파일을 포함시키는 것. <br />
만약 `package.json`에 `main`값이 없다면 
Node.js는 `index.js` 또는 `index.node`파일을 찾으려고 한다.

3. 2번과 똑같이 `index.node`를 포함시키는 것.



### 모듈 래퍼~module\ wrapper~
Node.js는 모듈 안에 있는 코드를 실행하기 전에 
아래와 같은 래퍼~wrapper~를 만들어 감싼다고 한다. 

```js
(function(exports, require, module, __filename, __dirname) {
// Module code actually lives in here
});

```
이럼으로써 모듈에 정의된 전역변수들이 
호출되어온 곳의 메모리 공간을 더럽히지 않게 된다. 
그리고 모듈에 로컬한 변수들은 프라이빗 변수가 된다.

### Core Modules
Node.js는 바이너리로 컴파일된 핵심 모듈들을 가진다. 
Node.js소스 안에 lib/ 폴더 안에 정의돼 있으며 
(바이너리로 컴파일 된 버전은 다른 폴더에 있는 듯하다)
`require` 함수에 다른 모듈보다 선호되기 때문에 
같은 이름을 가진 모듈이 있다고 해도 
핵심 모듈이 로드 된다. 
lib 폴더에 들어가보면 다음의 파일들을 볼 수 있다.
<details>
<summary>lib 폴더 보기</summary>
<p>
- assert.js
- async\_hooks.js
- buffer.js
- child\_process.js
- cluster.js
- console.js
- constants.js
- crypto.js
- dgram.js
- dns.js
- domain.js
- events.js
- **fs.js**
- **http.js**
- http2.js
- https.js
- inspector.js
- module.js
- net.js
- **os.js**
- **path.js**
- perf\_hooks.js
- process.js
- punycode.js
- **querystring.js**
- readline.js
- repls.js
- stream.js
- stirng\_decoder.js
- sys.js
- timers.js
- tls.js
- trace\_events.js
- tty.js
- **url.js**
- **util.js**
- v8.js
- vm.js
- woker\_threads.js
- zlib.js


</p>
</details>
 

## package.json
NPM 패키지를 소비하든 제작하든 package.json 문해력은
패키지의 메타정보에 쉽게 접근할 수 있게 해준다.
NPM 공식 문서에서 기본적인 정보를 추려 정리했다.

패키지를 후에 배포할 거라면, 
`name` 과 `version` 필드가 요구된다.
`version`필드는 Semantic Versioning 2.0.0을 따라
작성하면 된다.
  
  > **Semantic Versioning 2.0.0**에 따르면
  > MAJOR.MINOR.PATCH의 형식을 따르고,
  > MAJOR는 양립할 수 없는 API의 변화가 따를 때,
  > MINOR는 구버전과 양립할 수 있는 기능이 추가될 때,
  > PATCH는 구버전과 양립할 수 있는 버그 픽스를 할 때
  > 증가한다.

`files`는 `.gitigonre`와 비슷하지만 반대이다.
깃이그노어가 블랙리스트라면, 
`files`필드의 배열은 화이트리스트이다.
 기본값은 모든 파일을 포함시키는 `["*"]`.
`.npmignore` 파일도 있고, `.gitigonre`와 똑같이 
작용한다. 없으면 깃이그노어가 npm이그노어를 대신한다.

`bin`에 실행파일을 놓으면 `usr/local/bin/`아래 심볼링링크가 생긴다.
`http-server`와 같은 bash에서 바로 쓸 수 있는 
NPM 패키지들을 보면 이 항목을 활용하는 것을 볼 수 있다.[^http-server]


## 얻은 것들~rule\ of\ thumbs~
조사하며 얻은 실용적인 교훈은 다음과 같다. 
- 코어 모듈은 리콰이어에서 높은 우선순위를 갖는다.
- `require`함수는 주어진 모듈 identifier를 상위폴더로 가며
  가장 먼저 찾은 node\_modules폴더 안에서 찾는다. 
- `package.json`의 `main` 프로퍼티를 활용해 코어 결과물을 
  배포하면 되겠다.
- 트리쉐이킹~tree\ shaking~은 정적 구조의 모듈을 갖는
  esm부터 가능하구나.

## 참조

- [ExploringJS.com: Modules](http://exploringjs.com/es6/ch_modules.html#static-module-structure)
- [freeCodeCamp: Learn the basics of the JavaScript module system and build your own library](https://www.freecodecamp.org/news/anatomy-of-js-module-systems-and-building-libraries-fadcd8dbd0e/)
- [Node Official Documents](https://nodejs.org/api/modules.html)
- [Node github repository](https://github.com/nodejs/node/tree/master/)
- [require and the module system](http://fredkschott.com/post/2014/06/require-and-the-module-system/)
- [NPM Official Documents: package.json](https://docs.npmjs.com/files/package.json.html)
- [Semantic Versioning 2.0.0](https://semver.org/)

[^ECMA6\_Modules]: [MDN: import](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)
[^http-server]: [http-server: package.json](https://github.com/indexzero/http-server/blob/master/package.json)
