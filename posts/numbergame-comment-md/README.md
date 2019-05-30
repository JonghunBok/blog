---
title: 왜 나는 넘버게임을 풀지 못했나
date: 2018-06-20 22:05:02
tags: 음
 - algorithm
 - self-examination
intro:
 - 동적계획법을 연습하는 문제 'NUMBERGAME'을 풀지 못했다.
 - 정답과 나의 시도를 비교하며 내가 어떤 점을 놓쳤는지 살펴보려 한다.
 - 이 문제를 이미 풀었거나, 풀려고 시도한 경험이 있는 사람을 독자로 상정했다.
 - 문제는 아래 주소에서 확인할 수 있다.
 - -&nbsp;https://algospot.com/judge/problem/read/NUMBERGAME
---

## 나의 답안
```cpp
int doBest(int left, int right, int player) { 
    int& ret = cache[left][right][player]; 
    if (isCacheFilled[left][right][player]) return ret; 
     
     int case1[2] = {left + 1, right}; 
     int case2[2] = {left    , right - 1}; 
     int case3[2] = {left + 2, right}; 
     int case4[2] = {left    , right - 2}; 
                
    ret = max( 
      - doBest(case1[0], case1[1], !player) + numbers[left], 
      - doBest(case2[0], case2[1], !player) + numbers[right-1], 
      - doBest(case3[0], case3[1], !player) + 0,  
      - doBest(case4[0], case4[1], !player) + 0  
            ); 
             
    return ret; 
}
```

## 모범 답안
```cpp
int play(int left, int right) {
    if(left > right) return 0;
    int& ret = cache[left][right];
    if(ret != EMPTY) return ret;

    ret = max(board[left] - play(left + 1, right),
          board[right] - play(left, right - 1));

    if(right - left + 1 >= 2) {
        ret = max(ret, -play(left + 2, right));
        ret = max(ret, -play(left, right - 2));
            }

    return ret;
}
```
### 왜 나는 문제를 풀지 못했나
책과 나의 시도는 코드 자체도 상당히 유사하고, 접근법도 서로 같다. 그럼에도 불구하고 내가 답을 내지 못한 이유를 찾아보았다.

1. **기저사례를 명확히 하지 못했음**
  <br>위에 쓴 코드에는 빠져있지만, 문제를 풀면서 기저사례 처리를 위해 이런저런 시도를 해보았지만 계속 확신이 없었다. 그 이유는 두번째 이유와 이어진다.
2. **함수 호출을 나누어 한다는 발상을 못했음**
  <br>나는 하나의 표현식 안에 모든 경우의 수를 전부 한 번에 인수로 전달하려고 애썼다.
  굳이 그럴 필요는 없었는데 말이다. 
  특히 내가 정답의 10번 줄에 있는 표현식 처럼 max의 인수로 
  대입 연산자의 피연산자를 넣는 방식에 익숙치 않아서 더 그랬던 것 같다. 
  <br>&nbsp;&nbsp;&nbsp;&nbsp;그러다보니 left와 right와의 차이에 제약을 주지 못했다. 
  항상 case3와 case4까지 계산되다 보니 기저사례를 위한 조건식을 정할 때도 헷갈렸던 것 같다.

### 반성
깔끔한 코드를 짜는 것에 집착했고, 게으르게 사고했다. 다음부턴 기능을 하는 코드를 짜는 것을 우선하고, 문제 풀이가 막히면 다시 처음부터 생각해보는 것을 두려워하지 않아야겠다. 


