---
title: '컨테이너에서 돌아가는 애플리케이션의 GUI를 이용하는 법'
tags:
  - GUI
  - Docker
  - Container
  - 컨테이너
  - 도커
  - 그래픽 유저 인터페이
date: 2020-03-09T15:19:56.645Z
---
도커 컨테이너에서 실행된 애플리케이션의 화면을 내 모니터에서 볼 수 있을까? 가능하다! 어떤 사람들은 IDE, 웹브라우저, 심지어 윈도우 매니저까지 컨테이너에서 실행하기도 한다. 

흔히 알려진 ssh의 X11 포워딩과 vnc로도 컨테이너 내 애플리케이션의 화면을 볼 수 있지만, 두 방법 모두 좋은 속도를 내진 않는다. ssh는 디스플레이 정보를 암호화해서 전송하고 vnc는 컨테이너에서 렌더링을 한 후에 화면을 전송하기 때문에 일상적으로 사용할 만한 GUI 경험을 제공하지 못한다. 

하지만, 더 간단하고 쾌적하게 컨테이너 속 애플리케이션을 활용할 수도 있다. **윈도우 시스템**과 **디스플레이 서버**를 이해하고 이용해서, 로컬에서 돌아가는 것과 비슷한 속도로 컨테이너화한 프로그램의 GUI를 이용해 보자!

## 이론
리눅스 환경에서 가장 쉽게 볼 수 있는 X.Org 디스플레이 서버와 X11 윈도우 시스템을 기준으로 설명을 진행한다. 바로 실습으로 넘어가서 기작을 이해할 수 있다면 읽지 않아도 좋다. 

### 설명하는 용어
- 디스플레이 서버 (Display Server)
- 윈도윙 시스템 (Windowing System / Window System)

### 디스플레이 서버란?
![GUI의 기본 구성 (출처: 위키피디아)](https://i.imgur.com/tZhNrGP.png)

입출력 장치들 (마우스, 키보드, 모니터) 등은 모두 하드웨어다. 리눅스에서 하드웨어를 직접 제어하는 것은 리눅스 커널 뿐이다. 그렇다고 입출력을 알맞게 처리하기 위해서 모든 응용프로그램이 커널 API를 직접 소비한다면, 매우 비효율적일 것이다. '디스플레이 서버(윈도우 서버)'라는 개념은 이런 난점을 해결해준다. 

디스플레이 서버는 커널과 직접 소통하며 애플리케이션과 운영체제 사이에 입출력 정보 통신을 원활히 하는 프로그램이다. 여타 애플리케이션은 클라이언트로서 하드웨어 입출력 신호를 대신 처리해주는 서비스를 디스플레이 서버로부터 받는다. 

디스플레이 서버도 일종의 서버로, 클라이언트들과 통신 프로토콜을 이용해 정보를 주고 받는다. 이 프로토콜은 네트워크-투명(network transparent)할 수도 있고, 그저 네트워크-가능(network possible)일 수도 있다. 

윈도우 안에 GUI를 제공하는 모든 애플리케이션은 디스플레이 서버의 클라이언트인 셈이다. 디스플레이 서버는 WIMP(Windows, Icons, Menus, Pointer) GUI를 지원하는 **윈도윙 시스템**의 핵심 부품이다.

### X Window System (X11, X)에 대하여
X11는 프로토콜의 집합일 뿐이다. X11 시스템을 갖는다는 것은 이 프로토콜을 준수하는 소프트웨어의 집합을 유지한다는 의미이다. 보통 X11 시스템인 윈도윙 시스템을 X11 또는 X라 한다. 

X는 유닉스 계열 운영체제에서 쉽게 볼 수 있는 비트맵 디스플레이를 위한 윈도윙 시스템이다. 디스플레이 장치에 윈도우를 만들고 움직이거나, 마우스나 키보드와 같은 입력장치와의 기본적인 상호작용을 지원하는 *프레임워크*이다. X는 1984년에 MIT에서 시작되었으며, [X.Org](https://www.x.org/wiki/)에서 오픈소스 구현을 제공하며 프로젝트를 이끌고 있다.

X는 네트워크 투명성을 지원한다는 점에서 특별하다. 네트워크 상에 있는 다른 컴퓨터에서 돌아가는 프로그램의 화면도 볼 수 있게 해준다. 그렇기 때문에 우리가 도커 컨테이너에서 돌아가는 프로그램의 화면을 볼 수 있다. 

### 서버-클라이언트 
![X 시스템 구성도 (이미지 출처: 위키피디아)](https://i.imgur.com/uVvgOvD.png)

실제 사용자 앞에 있는 컴퓨터에서 꼭 돌아가야 하는 건 결국 디스플레이 서버다. 다분히 애플리케이션의 관점에서 이루어 용어 선택이라, 처음엔 헷갈릴 수 있다. 애플리케이션이 로컬에서 돌아가든, 네트워크 어딘가에서 돌아가든, 애플리케이션은 디스플레이 서버의 클라이언트이다. 위에서 말했듯, 입출력 자원을 커널을 통해 관리하는 서비스를 디스플레이 서버가 담당하며 클라이언트를 대신 해 사용자의 마우스 클릭을 받고, 커널에 그래픽 렌더링을 요청한다. 

ssh의 X포워딩 기능을 이용하는 것도 같은 원리다. 다만 윈도우즈 운영체제에서는 X포워딩 기능을 이용하기 위해선 Xming을 설치해야 하는데, 그건 기본 윈도우즈에 X서버가 없어서, X 서버의 윈도우용으로 포팅된 버전을 설치하는 것이다. Xming은 '윈도우즈를 위한 X 서버'이다.

우리는 도커 컨테이너 내에서 돌아가는 X 클라이언트인 프로그램이 호스트에서 실행되고 있는 X 디스플레이 서버에 접속할 수 있게 해주면 되는 것이다.

## 실습
결국 우리가 해야 하는 일은,

1. 컨테이너를 실행할 때 
   - 디스플레이 소켓을 마운트하고
   - 컨테이너 내에 디스플레이 환경 변수를 보내주고
2. 컨테이너 실행 후에
   - `xhost` 명령어를 이용해 컨테이너 내 애플리케이션이 호스트의 디스플레이 서버에 접속할 수 있게 허가 해준다

3. 컨테이너 정지 후에
    - `xhost` 명령어를 이용해 종료한 컨테이너를 X 서버 접속 허가 리스트에서 지운다
```bash
docker container run \ 
    -v /tmp/.X11-unix/:/tmp/.X11-unix \ # 소켓 마운팅
    -e "DISPLAY" \ # 환경 변수 전달
    --name container_name 
    image_name
    
    
xhost +local:`docker container ls -f name=container_name -q`
# 또는 xhost +local:host

# 컨테이너 종료 후에
xhost -local:`docker container ls -f name=container_name -q`
# 또는 xhost -local:host
```

윈도우즈에서 도커를 이용할 경우에 DISPLAY 환경 변수를 다르게 설정해줘야 한다. 아래를 시도해 볼 것을 권한다.

```bash
# 컨테이너 안에서 실행
export DISPLAY=`cat /etc/resolv.conf | grep nameserver | awk '{print 2}'`:0 

# cat /etc/resolve.conf
# 를 하면 사용하는 네임서버의 목록이 나온다.
# grep
# 으로 nameserver라는 텍스트가 등장하는 줄을 골라내서
# awk
# 로 ip 부분만 가져온 후에 :0을 붙여서 DISPLAY라는 환경변수에 넣어준 것이다.
```

## 요약
- 윈도윙 시스템은 기본적인 윈도윙을 제공한다.
- 디스플레이 서버는 윈도윙 시스템의 핵심이다.
- 클라이언트인 애플리케이션을 내가 GUI를 볼 수 있게 해주는 디스플레이 서버에 접속시켜야 한다.
- 컨테이너에 디스플레이 통신에 쓰이는 소켓을 마운트해주고, 호스트에서 권한을 주면 된다.

## 덧붙이는 이야기
- 이 방법 외에도 다양한 방법이 있다. 더 알고 싶다면 [ROS의 튜토리얼](http://wiki.ros.org/docker/Tutorials/GUI)을 추천한다.
- `Xephyr`이라는 툴을 이용하면 virtual display를 만들어 이용할 수 있다고 한다. 아직 구력이 부족해 그 효용을 이해하진 못하겠다...
- Wayland가 X11을 대체하고 주 디스플레이 프로토콜이 될 거라는 이야기가 있지만, 아직까진 X가 대세인 것 같다.
- 윈도우에서 도커 컨테이너를 생성할 때, 컨테이너의 네임서버가 호스트를 바라보게 하는 것 같다. 기회가 있을 때 구체적인 기작을 공부해보고 싶다.
---
### 참고 링크
- http://wiki.ros.org/docker/Tutorials/GUI
- https://en.wikipedia.org/wiki/Display_server
- https://en.wikipedia.org/wiki/Windowing_system
- http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
- https://www.linux.org/threads/display-servers-windowing-systems.10456/
- https://en.wikipedia.org/wiki/Network_transparency