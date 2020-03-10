---
title: 동적계획법에 대해
tags:
  - algorithm
  - 동적계획법
  - Dynamic Programming
  - 다이나믹 프로그래밍
  - 코딩테스트
date: 2019-09-21 01:29:15
---
> *"(동적계획법은) 프로그래밍 대회 문제에 가장 자주 출현하는 디자인 패러다임"*[^종만북_인용1]

<br>

동적계획법을 공부하기 위해 먼저 알아두면 좋은 개념들을 살펴보고, 
알고리즘 문제 해결을 위한 이론을 정리한 후에, 간단한 연습문제를 풀어 보았다.


---
## 선행 개념
### 분할 정복
문제를 더 작은 부분 문제로 나누어 해결하고, 그 결과를 이용해 원래 문제의 답을 구하는 기법이다. 

### 중복 부분 문제
문제를 부분 문제로 나누어 해결할 때 같은 부분 문제를 중복해 풀어야 하면, 문제가 중복 부분 문제를 가진다고 한다.

### 메모이제이션
한 번 계산된 함수의 결과값들을 저장해서 사용하는 최적화 기법이다.

### 참조적 투명성
표현식이 프로그램의 행동에 변화를 주지 않으면서, 그 결과값들로 완전히 대체될 수 있을 때 참조적으로 투명~referentially\ transparent~하다고 한다. 참조적으로 투명하기 위해선 표현식이 '순수'해야 한다.

### 최적 부분 구조
*=Optimal Substructure*, 문제의 최적해가 부분 문제의 최적해들로부터 구축될 수 있다면 그 문제는 최적부분구조를 가진다고 한다.

---

## 동적계획법이란 
동적계획법~Dynamic_Programming~은 
- **메모이제이션**을 이용하는 **분할정복**이다. 

여기서 'programming'은 코딩같은 걸 말하는게 아니라 '표'를 사용하는 방법을 뜻하는데[^ITA_인용1], 메모이제이션이 일종의 표(주로 배열~array~이나 해쉬테이블~hash\ table~)를 사용하기 때문이다. 메모리를 더 사용해서 속도를 얻어내는 기법의 전형이다.

문제가 **최적 부분 구조**와 **중복 부분 문제**를 가진다면, 동적계획법을 고려해봐야 한다. 동적계획법은 다음의 4단계의 과정을 통해 사용된다.[^ITA_인용2]

1. 최적해의 구조를 알아낸다.
2. 최적해를 재귀적으로 정의한다. (*= 점화식을 찾는다*)
3. 최적해의 값을 계산한다, 일반적으로 상향식으로 계산한다.
4. 계산된 정보로부터 최적해를 만들어 낸다.

>원문: 
>1. Characterize the structure of an optimal solution.
>2. Recursively define the value of an optimal solution.
>3. Compute the value of an optimal solution, typically in a bottom-up fashion.
>4. Construct an optimal solution from computed information.

3번 단계에서 추가적인 정보를 따로 저장하면, 4번 단계를 쉽게 수행할 수 있다. 만약 최적해의 '값'만 필요한 것이라면 4번 단계를 생략해도 좋다.
## 메모이제이션에 대하여
동적계획법에서 부분해를 얻는 함수를 사용할 때, 함수가 호출되는 문맥과 시기에 상관없이 최조로 계산되었던 값을 반환하기 때문에, 부분해를 구하는 함수가 **참조적으로 투명**해야 한다.

메모이제이션을 하는 방법은 두가지가 있다.
1. 하향식 ~top-down~
    최적해의 구조를 이용해 재귀함수를 만들고, 그 함수로 원하는 값을 계산하는 방법.
3. 상향식 ~bottom-up~
    부분 문제를 크기 순으로 정렬하여, 순서대로 푸는 방법. 이렇게 하면 각 부분 문제를 풀 때 필요한 더 작은 부분 문제들은 이미 계산이 되어있게 된다. 주로 반복문을 사용해 구현한다.
    
하향식으로 접근하는 게 논리적으로 자연스럽고 구현도 쉽다. 하지만 재귀함수로 구현을 하면 함수 호출로 인한 오버헤드가 발생하고, 드물게 모든 부분 문제를 풀지 않을 수 있기 때문에 주의가 필요하다. 문제 풀이를 할 때, 하향식으로 먼저 풀고 그 후에 상향식으로 다시 풀면 좋은 연습이 될 것이다.

## 예시 문제 (1, 2, 3 더하기)
백준 사이트에서 [9095번 문제](https://www.acmicpc.net/problem/9095)를 풀어보자. 문제의 요구는 다음과 같다.
> 정수 n이 주어졌을 때, n을 1, 2, 3의 합으로 나타내는 방법의 수를 구하는 프로그램을 작성하시오.

이 문제를 하향식과 상향식으로 각각 한 번 씩 풀어보았다. 1. 문제 풀이법을 잠시 생각해보고, 2. 코드를 읽고 이해한 후에, 3. 처음부터 끝까지 직접 구현해보자.

### 풀이 1; 하향식 접근
```cpp
#include <iostream>

using namespace std;

int dp[11];

int count(int n)
{
  if (n < 0) return 0;
  if (n == 0) return 1;
  if (dp[n] != 0) return dp[n];

  return dp[n] 
      = count(n - 1) + count(n - 2) + count(n - 3);
}

int main()
{
  int T;
  cin >> T;

  while (T--) {
    int n;
    cin >> n;
    cout << count(n) << endl;
  }

  return 0;
}
```

### 풀이 2; 상향식 접근
```cpp
#include <iostream>

using namespace std;

int main() 
{
  int dp[11] = {0, };
  dp[0] = 1;
  dp[1] = 1;
  dp[2] = 2;
  for (int i = 3; i <= 10; i++) {
    dp[i] = 
      dp[i - 1] + dp[i - 2] + dp[i - 3];
  }

  int T;
  cin >> T;
  while (T--) {
    int n;
    cin >> n;
    cout << dp[n] << endl;
  }

  return 0;
}
```

## 풀어봄직한 문제
- [백준 2579번: 계단 오르기](https://www.acmicpc.net/problem/2579)
- [백준 11050번: 이항 계수 1](https://www.acmicpc.net/problem/11050)
- [백준 11051번: 이항 계수 2](https://www.acmicpc.net/problem/11051) 
- [백준 1965번: 상자넣기](https://www.acmicpc.net/problem/1965)


## 읽어볼 자료
- [위키: 참조적 투명성](https://en.wikipedia.org/wiki/Referential_transparency)
- [위키: 최적부분구조](https://en.wikipedia.org/wiki/Optimal_substructure)
- [위키: 중복부분문제](https://en.wikipedia.org/wiki/Overlapping_subproblems)


[^종만북_인용1]: *종만북 p.207*
[^ITA_인용1]: *Introduction To Algorithm, 3rd Edition, p.359*
[^ITA_인용2]: *같은 책, 같은 쪽*

