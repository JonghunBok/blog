---
title: '웹개발 TDD 입문, Jest의 Matchers 정리'
date: 2021-01-23T12:27:04.223Z
---

![대청소는 어렵다. <br/> 작은 정리를 계속해야 깨끗한 코드베이스를 유지할 수 있다.](./uncle-bob-tdd.png)

Test-driven Development(TDD)를 항상 하고 싶었다.
Clean Code 강의를 듣기 시작하면서, 이 생각이 더 커졌다.
책의 저자이자 강의자인 Uncle Bob이 TDD를 무척이나 강조하기도 하고,
TDD의 장점을 논리적이고 매력적으로 설명해주었기 때문이다.
그 중 무엇보다 마음에 들었던 것은 '좋은 테스트가 있으면,
리팩토링에 두려움이 없어진다'는 것이다.

더 나은 엔지니어가 되기 위해 TDD(Test-driven Development)를 실천해보고자 한다.
Javascript 진영에서는 어떤 테스팅 툴이 있는지,
특히 내가 사용하는 Vue.js에서는 어떤 툴이 널리 쓰이는지 조사했다.
영상과 도큐먼트들을 살펴보며 유닛 테스트를 먼저 해보기로 하고 Jest를 선택했다.

[Vue.js의 테스팅 가이드](https://vuejs.org/v2/guide/testing.html)와 
[Jest의 공식 도큐먼트](https://jestjs.io/docs/en/using-matchers)를 크게 참조하며
다음을 가볍게 정리해보았다:

- 웹개발에서 사용되는 테스트의 종류
- Jest의 시작인 Matchers의 종류

## 웹개발에서 사용되는 테스트의 종류

웹개발에 있어서는 크게 세 가지의 테스트가 있다.

| 종류 | 역할 | 라이브러리/솔루션 |
| --- | --- | --- |
| Unit Testing | 말 그대로 작은 유닛을 대상으로 하는 테스트 | Jest, Mocha ( + Chai) |
| Component Testing | UI 컴포넌트가 의도한 대로 작동하는지를 테스트 | Vue Testing Library (@testing-library/vue) |
| End-To-End(E2E) Testing | 인프라와 백엔드를 포함하여 실제로 웹이 배포되었을 때 문제 없는지를 테스트 | Cypress.io, Nightwatch.js, Puppeteer, TestCafe |

### 유닛 테스팅~Unit\ Testing~

작은 코드 유닛들을 테스트하는 것을 *유닛 테스팅*이라고 한다.
함수의 출력값이 예상값과 같은지를 확이하는 Assertion이라고 생각할 수 있다.
함수를 작성하기 전에 어떤 입력에 대해 어떤 출력을 기대하는지를 테스트로 작성하고,
그 테스트를 통과하기 위해 실제 함수를 작성하는 것이 일반적이다.

프로그래머스와 LeetCode와 같은 알고리즘 문제풀이 사이트를 경험해보았다면,
이미 다른 사람이 작성한 테스트를 통과하기 위해 함수를 작성했다는 점에서
유닛 테스팅을 한 경험이 있는 것이다.

TDD의 기본기이고, 후에 컴포넌트 테스팅에서도 같은 툴을 이용하기도 하기 때문에
잘 정리해두는 것이 좋을 것 같다.

### 컴포넌트 테스팅~Component\ Testing~

Vue 뿐만 아니라, 많은 프론트엔드 프레임워크들이 UI 구성요소를 하나의 컴포넌트로 다룬다.
컴포넌트가 DOM 엘리먼트로 마운트 됐을 때, 의도한 대로 작동하는지를 테스트하는 것을
*컴포넌트 테스팅*이라고 한다.

사용자가 UI와 상호작용할 때, 개발자의 의도대로 UI 컴포넌트가 작동하는지를 확인하는 중요한 단계이다.
실제 제품 사용자 뿐만 아니라 다른 개발자가 해당 컴포넌트를 사용할 때도
동의된 컴포넌트 계약~Component\ Contract~[^component-contract]대로 구현되었는지 확인해야 하기 때문에
특히 더 중요한 테스트인 것 같다.

후에 컴포넌트 테스팅을 할 때도 VTU(Vue Testing Utility)와 함께 
Jest를 흔히들 사용하는 것 같다.

### End-To-End(E2E) Testing

실제로 배포되었을 때 예상치 못한 버그가 생기지는 않는지 확인하는 테스팅이다.
프론트엔드는 항상 백엔드와 긴밀히 협력하기 때문에 프론트엔드의 코드만으로는
실제 필드에서 정상 작동할 수 있는지 알 수 없다.
최대한 실제 서비스 환경과 비슷한 환경에서 점검을 하는 단계라고 생각하면 될 듯하다.


## Jest의 시작, Matchers

Jest는 보통 함수의 반환값을 인자로 받는 `expect` 함수를 제공한다.
이 함수는 받은 인자를 토대로 'expectation' 객체를 반환한다.
많은 테스트가 이 객체에 붙어 있는 'matchers'라고 불리는 메소드들을 호출함으로써 작성된다.

```js
// 예시
test('two plus two is four', () => {
  expect(2 + 2).toBe(4);
});
```

아래는 기본적인 matchers를 정리한 표이다.

| 예상값 타입 | 함수명 | 설명 | 요약 |
| --- | --- | --- | --- |
| 동일성 | `.toBe` | 내부적으로 ECMAScript 2015의 `Object.is`를 사용한다. | `===` |
|        | `.toEqual` | 재귀적으로 객체를 돌면서 각 value가 같은지 확인한다. | `_.isEqual` |
| 참거짓 | `.toBeNull` | 오직 `null`과 같은지를 확인한다. | `=== null` |
|        | `.toBeUndefined` | 오직 `undefined`과 같은지를 확인한다. | `=== undefined` |
|        | `.toBeDefined` | `undefined`이 아닌지를 확인한다. | `!== undefined` |
|        | `.toBeTruthy` | `if`문이 참이라고 받아들일 값인지 확인한다 | `!!` |
|        | `.toBeFalsy` | `if`문이 거짓이라고 받아들일 값인지 확인한다 | `!` |
| 숫자   | `.toBeGreaterThan` | 함수명 그대로이다. | `>` |
|        | `.toBeGreaterThanOrEqual` | 함수명 그대로이다. | `>=` |
|        | `.toBeLessthan` | 함수명 그대로이다. | `<` |
|        | `.toBeLessThanOrEqual` | 함수명 그대로이다. | `<=` |
| 문자열 | `.toMatch` | 정규표현식을 인자로 받아 매치가 일어나면 참이다. | `String.prototype.match(regexp) !== null` |
| 배열과 반복 가능한 객체~iterables~ | `.toContain` | 배열 또는 반복 가능한 객체가 특정 요소를 포함하는지 확인한다. | `Array.prototype.includes(result)` |
| 예외 발생 여부 | `.toThrow` | 함수가 호출될 때 에러를 던지는지 확인한다.  |  |


`.toThrow`의 경우 다음과 같이 감싸는 함수를 작성해야 테스트가 실패하지 않는다:

```js
function compileAndroidCode() {
  throw new Error('you are using the wrong JDK');
}

test('compiling android goes as expected', () => {
  expect(() => compileAndroidCode()).toThrow();
  expect(() => compileAndroidCode()).toThrow(Error);

  // 인자로 에러 메시지나 정규표현식을 넣을 수도 있다.
  expect(() => compileAndroidCode()).toThrow('you are using the wrong JDK');
  expect(() => compileAndroidCode()).toThrow(/JDK/);
});
```

## 결론

GUI를 만드는 프론트엔드의 특성상,
서버 개발자와 TDD에 접근하는 방식이 조금 달라야 한다고 한다.
기본이 되는 유닛 테스트와 간단한 Matchers에 우선 익숙해지며
웹개발을 위한 TDD의 세계에 들어가면 좋겠다.
나 스스로 높은 코드 품질을 보장하는 개발자가 되기를 바라고,
같은 목표를 갖는 분들께 조금이라도 도움이 되었기를 바라며 글을 마친다.


[^component-contract]: 컴포넌트 계약은 컴포넌트 개발자와 컴포넌트를 소비하는 개발자 사이에 있는 컴포넌트가 어떻게 행동할지에 관한 약속이다.
