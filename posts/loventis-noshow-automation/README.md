---
title: 게하의 일을 자동화해보았다
tags:
  - guest house
  - loventis
  - automation
  - javascript
  - chrome extension
categories:
  - project
date: 2018-06-07 17:19:16
intro:
  - 요약
  - 1. 게하에서 주기적으로 하는 단순 반복 작업이 있다.
  - 2. 이 작업을 보조 해주는 크롬 익스텐션을 만들었다.
  - 3. SPA를 이용한 업무를 자동화하기 알맞았다.
  - 4. js 이용자가 업무 공동체에 기여할 수 있는 좋은 수단같다.
refs:
  - 1. Single Page Application, 페이스북과 같이 단일 페이지로 구성된 웹앱을 일컫는다.
---
게스트 하우스에서는 매일매일 해야하는 지루한 작업이 몇가지 있다. 아래처럼 클릭, 클릭, 클릭을 반복한다. 

![노쇼 처리 작업 일부.](./tedius_work.gif)

&nbsp;&nbsp;&nbsp;&nbsp;내가 일하는 게스트하우스에서는 예약 관리를 Loventis의 웹앱을 이용해서 한다. 이 웹앱은 왠만해선 페이지가 새로고침 되지 않는 SPA<sup>1</sup>이다. 그러다보니 작업의 일부를 간단한 DOM 제어를 통해 자동화하기 쉽다. 
&nbsp;&nbsp;&nbsp;&nbsp;처음엔 크롬 개발자 도구가 지원하는 스니펫<sub>snippet</sub>기능을 이용했다. 같이 일하는 스태프에게도 설명 해줄 때 'F12를 누르고 Source 를 누르고 Snippet을 누르고 특정한 스니펫을 고르고 Ctrl+Enter를 누르면 된다'라는 식으로 말했다. 그런데 여기서 마음에 걸렸던 게, 다른 사람에게 가르쳐줄 때 장화앟게 설명을 해줘야 하고, 배우는 사람도 새로운 용어를 익혀야 하는 부담이 있었다.
&nbsp;&nbsp;&nbsp;&nbsp;어쩌면 내가 잘난 척을 하고 싶었던 걸까? 하는 의문도 생겼다. 크롬 개발자 도구를 모르는 사람에게 어떻게 더 쉽게 사용법을 가르쳐주고, 더 간결한 UX를 줄 수 있을까 고민했고, 나는 크롬 익스텐션<sub>chrome extension</sub>을 만들기로 했다.  
&nbsp;&nbsp;&nbsp;&nbsp;
![크롬익스텐션을 도입했다.&nbsp;
가장 왼쪽의 익스텐션이 노쇼처리 자동화 익스텐션이다.](./introduce_extension.jpg)

&nbsp;&nbsp;&nbsp;&nbsp;[크롬 공식 사이트](https://developer.chrome.com/extensions)를 통해서 익스텐션의 기본 구조를 공부해서 만드느라 시간이 생각보다 오래 걸렸다. 하지만 그럴 가치가 있었고, 함께 지냈던 스태프들과의 추억을 남기며 했기 때문에 즐겁게 일을 할 수 있었다. 아래가 완성된 모습이다.

![노쇼 처리 일부를 자동화한 모습.](./noshow_modeon.gif)
&nbsp;&nbsp;&nbsp;&nbsp;가장 위의 그림과 정확히 같은 작업을 하는 그림이다. 노쇼 모드를 키고, 노쇼처리 하고 싶은 블록을 클릭만 하면 나머지는 익스텐션이 알아서 해준다.
&nbsp;&nbsp;&nbsp;&nbsp;해당 업무를 담당하던 스태프가 업무가 크게 편해졌다고 말해주어 기뻤다. 작은 프로젝트였지만, 이번 기회로 크롬 익스텐션을 이용한 업무 자동화가 JS 사용자로서 업무 공동체에 기여할 수 있는 담백하면서도 효과적인 방법이라는 생각을 할 수 있었다. 

<details>
<summary>사용한 기술</summary>
<p>
 - Vanila Javascript <br />
 - Chrome Extension <br />
 - Materialize 
</p>
</details> 
