---
title: Vagrant와 Ansible로 하는 서버 관리 기초
tags:
  - DevOps
  - Ansible
  - Vagrant
  - Operation
  - Container
  - Docker
  - VM
  - Automation
date: 2020-05-25 12:12:40
---
  공용 서버를 관리하게 된 초보 인프라 관리자와 *서버 세팅 자동화*에 관심이 있는 개발자/연구자의 시름을 덜기 위해 (무엇보다 글쓴이가 나중에 참고하기 위해) 시행착오하며 공부한 내용을 정리해두고자 한다. 이 글에선 **Vagrant**와 **Ansible**을 이용해 **눈송이 서버**를 **불사조 서버**로 전환하는 데 활용할 수 있는 워크플로우와 이 과정을 이해하는데 필요한 기본적인 개념들을 정리한다. 
  
## 배경 설명
  독자에게 자동화의 필요성이 좀 더 잘 와닿았으면 하는 바람으로, 직접 겪은 문제들을 먼저 공유해보고자 한다. 글쓴이는 운이 좋게도(?) 인턴으로 있는 랩에서 공용으로 사용하는 서버 컴퓨터들을 관리하게 되었다. 각 연구원이 개인용으로 사용하고 있던 머신들을 모아서 공용 클러스터를 구축하는 임무를 맡았는데, 컴퓨터 대수가 많지 않고 자동화 툴들에 익숙치가 않다는 이유로, 각 머신을 직접 세팅하고 서버실에 올리겠다는 어리석은 판단을 하고 말았다. 그러니 다음과 같은 상황이 벌어지고 말았다...

> *연구원: "서버에서 도커 쓸 수 있나요?" <br>
> 글쓴이: "네, 서버 한 대 한 대에 직접 다 설치해서 확인했습니다!" <br>
> 연구원: "오, GPU도 사용할 수 있나요?" <br>
> 글쓴이: "네, 이번에 전부 세팅해놓았습니다!" <br>
> 연구원: "근데 5번 노드에선 도커 --gpus 옵션이 작동 안하는데요?" <br>
> 글쓴이: "네...?"*

이런 상황 외에도, 각 노드에 각 연구원을 위한 유저 아이디를 만들고 관리하는 작업과 Docker의 기본 브릿지 아이피 대역을 바꾸는 것, 공통으로 필요한 툴 설치 등 사소할 수 있는 업무가 계속 생성되는데, 서버를 일일이 돌며 작업을 하는 것은 결코 사소하지 않았고 인수인계도 힘들었다. 결국 자동화의 길로 들어서게 됐다. 

기본적인 용어부터 정리해보자. 

## 기본 개념 정리 
- **버츄얼박스 VirtualBox** <br>
  버츄얼박스는 호스트 OS위에 애플리케이션으로서 돌아가는 type 2 하이퍼바이저(hypervisor)이고, 오라클에서 관리하는 범용 x86 하드웨어 풀 버츄얼라이저이다.[^about_virtualbox]  가상 머신을 이용할 수 있게 해주는 소프트웨어로 이해하면 된다. 

- **베이그란트 Vagrant** <br>
   VM들을 쉽게 관리하게 도와주는 커맨드라인 툴이다. 워크플로우를 개선하고 자동화에 집중할 수 있게 해주면서, "내 컴퓨터에선 됐는데..."라는 별명을 과거의 유물로 만든다는 게 공식 문서의 설명.[^intro_to_vagrant] 이 글에서는 기초적인 커맨드만 사용한다. 

- **앤서블 Ansible** <br>
  앤서블은 놀랍도록 간편한 IT 자동화 엔진이다.[^how_ansible_works] ssh로 연결할 수 있고 파이썬이 설치된 머신이라면 앤서블로 관리할 수 있다. 대부분이 파이썬으로 작성됐지만 파이썬을 몰라도, YAML만 이해한다면 바로 사용할 수 있다. 비슷한 일을 하는 툴들로는 **Puppet**, **Chef** 등이 있지만, 그 중에 앤서블만이 CNCF(Cloud Native Computing Foundation)의 플래티넘 멤버이다...! 앤서블은 레드햇에 인수되어 관리되고 있다.[^cncf_ansible]

- **눈송이 서버 Snowflake Server**[^snowflake_server] <br>
  위의 배경에서 내가 구성한 서버가 바로 눈송이 서버이다. 세상에 하나밖에 없고, 없어지면 다시 똑같이 재현해 내기가 거의 불가능하다는 뜻에서 눈송이 서버라 불린다. 주로 수동으로 이것저것 설치하고 환경설정도 바꾸면서 만들어진다. 인프라 관리자로서 가장 경계해야 하는 게 눈송이 서버를 만드는 게 아닐까싶다. 눈송이가 녹으면, 후임은 다시 처음부터 새로 세팅을 해야 한다. 

- **불사조 서버 Pheonix Server**[^pheonix_server] <br>
   넷플릭스에서는 *카오스 몽키*라는 툴을 만들어 임의적으로 서버를 (비유적으로) 불태우는 것을 아는가? 커다란 시스템이 서버가 망가지는 사건/사고/재해에 견딜 수 있는지를 확인하기 위함이라고 한다. 눈송이 서버가 시스템을 주로 이룬다면 상상도 할 수 없는 테스트이다. 눈송이의 반대는 뭘까? 불타 죽어도, 그 잿더미로부터 다시 태어나는, 불사조다! 그 구성이 문서화/자동화 되어있어 언제든 똑같은 서버를 만들 수 있는 서버를 불사조 서버라고 부른다. 
   
   불사조 서버의 용례를 좀 더 자세히 알고 싶다면 [조대협님의 글](https://bcho.tistory.com/1224)[^bcho_manse]을 추천한다. 
   
   
- **IaC (Infrastructure as Code)** <br>
  코드로서의 인프라. 머신에 접속해 커맨드라인 인터페이스에서 명령어를 하나씩 입력해 환경을 관리하는 게 아니라, 스크립트 파일이나 추구하는 환경의 상태가 정리되어 있는 YAML 파일 등으로 관리하는 방법론을 일컫는다. 후에 어떻게 환경이 설정되어 있는지 코드를 보고 쉽게 알 수 있고, 코드이다보니 무려 버전 관리도 할 수 있다! [위키피디아](https://en.wikipedia.org/wiki/Infrastructure_as_code)에 관련 정보가 매우 정리가 잘돼있어 더 자세히 알고 싶다면 일독을 권한다. 

## 목표
이 글은 이제까지 한 모든 자동화 작업을 정리하는 게 아니라, 기본적인 워크플로우를 소개하는데 집중한다.

- **실제 머신에 Ansible Playbook을 적용하기 전에 가상 머신에서 충분히 실험해 볼 수 있다.** <br>
  앤서블에서는 원하는 머신의 상태를 서술한 파일을 **플레이북 Playbook**이라고 부른다. Vagrant를 이용해 간편하게 VM을 만들어 실험해 본 후에 적용하자. 

- **머신에서 Docker를 사용할 수 있게 한다.** <br>
  공용서버에선 아무나 sudoer여서는 안된다. 각자가 원하는 버전의 툴을 설치하다보면, 네임스페이스를 어지럽혀 다른 사람의 연구/개발을 방해할 수 있기 떄문이다. Ansible을 이용해 도커 런타임을 설치해보자.

## 워크플로우 
사용하는 워크플로우는 단순하다. Vagrant를 이용해 가상 머신을 로컬 환경에서 만들고 시행착오하며 앤서블 플레이북을을 만들어 낸 후에, 새로운 가상 머신 인스턴스를 생성해서 작성한 플레이북이 원하는대로 환경을 만들어내는지 확인하고 나서, 실제 머신에 플레이북을 적용하면 된다. 

이를 단계를 나누어 설명해보았다. 

### 0. 필요 툴 설치
이 튜토리얼을 따라하려면, 다음의 툴들을 설치해야 한다. 클릭하면 설치법이 있는 공식문서가 열릴 것이다. 각 툴의 사용법은 아래 코드의 주석으로 짧게 설명한다. 이 글은 리눅스 환경을 가정하고 작성됐다. 

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/intro/getting-started/install.html)

### 1. 샌드박스 생성
```bash
# 실제 머신에 설치할 OS를 가진 VM 이미지를 받아온다.
# 여기선 우분투 18.04 버전 이미지를 이용했다. 
vagrant init geerlingguy/ubuntu1804

# 위의 명령어의 결과로 Vagrantfile이 만들어졌을 것이다.
# 이 파일에 적힌 정보를 이용해 다음의 명령어가 인터넷에서
# vm 이미지를 다운로드하고 
# 설치된 하이퍼바이저를 이용해 인스턴스를 생성할 것이다. 
vagrant up

# 인스턴스를 멈추려면 
# vagrant down
# 인스턴스를 없애려면
# vagrant destroy
# 하면 된다. 정말 간편하지 않은가!

# 다음 명령어를 이용하면 vagrant라는 유저로 
# 방금 생성한 vm 인스턴스에 ssh 접속이 된다. 
# 아직 docker가 없다는 것을 확인하고 
# exit를 치거나 Ctrl+d 를 눌러 나오면 된다. 
vagrant ssh
```
### 2. Vagrantfile 편집 (optional)
Vagrantfile을 아래와 같이 바꾸면 `vagrant provision`이라는 명령어로 같은 디렉토리에 있는 `playbook.yml` 플레이북을 적용할 수 있게 된다. 이렇게 하지 않고 따로 [앤서블 인벤토리](https://docs.ansible.com/ansible/2.3/intro_inventory.html)를 만들고 `ansible` 커맨드를 이용해도 된다. 다만, 이렇게 할 수 있는 독자는 이 이후로는 읽을 필요가 없다. 
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end
```

### 3. 앤서블 플레이북 작성 

앤서블을 이용하려면 **인벤토리Inventory**와 **플레이북Playbook** 개념을 알아야 한다. 2번 단계처럼 Vagrantfile을 편집했다면, 인벤토리를 직접 작성하지 않고 플레이북만 작성해 실험할 수 있지만 후에 실제 머신을 관리하기 위해선 인벤토리 파일을 작성해야 하니 어떻게 작성하는지 알고 있어야 한다. 
#### 인벤토리 작성법
인벤토리는 YAML 형식으로도 작성할 수 있지만, 보통 INI 파일의 형식을 따르고, 노드들을 그룹으로 묶어 관리할 수 있는 기능을 제공한다. 이 글에선 따로 작성하지 않으니, 기본 템플릿만 소개한다. 
```ini
# 노드를 묶을 그룹 이름
[그룹 이름] 
192.168.x.x # 관리할 노드의 호스트명 또는 아이피 주소

# 그룹에 대해 사용할 변수 목록 
[그룹 이름:vars]
ansible_user=vagrant
```

#### 플레이북 작성법
플레이북은 크게 두 부분으로 나뉜다. 
1. **어떤 노드들에 어떤 유저로 작업할지 명시하는 부분** <br>
   플레이북에서 사용할 변수들도 여기에 선언한다.

2. **작업 목록** <br>
   앤서블에서 작업은 테스크라는 단위로 나누어 관리한다. 테스크는 이름, 사용할 모듈, 모듈에 넣을 인수 목록을 포함한다. 어떤 작업인지 이름을 넣어서 어떤 작업인지 알 수 있게 하자. 

#### 앤서블의 모듈
앤서블에선 작업을 실행할 때 사용하는 스크립트를 모듈이라 부른다. `ping` 모듈을 사용하면, 관리하는 노드들이 살아 있고 네트워크 연결이 되어 있는지 쉽게 확인할 수 있고, `command` 모듈을 사용하면 원격으로 커맨드라인 툴을 사용할 수 있다. 각종 패키지 매니저 모듈도 있는데, 여기선 우분투 머신을 세팅하니 `apt` 모듈을 사용할 것이다. 

앤서블을 설치하면 아주 다양한 모듈이 딸려 오는데, 개중에 특히 도움이 되는 모듈들이 있다. 더 자세히 알고 싶다면 [알아두면 좋은 10가지 모듈](https://opensource.com/article/19/9/must-know-ansible-modules)을 읽어보자.

#### 예시 
아래 플레이북 예시는 도커 런타임을 설치한다. [디지털오션의 튜토리얼](https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-docker-on-ubuntu-18-04)과 [도커 공식 설치 가이드](https://docs.docker.com/engine/install/ubuntu/)를 참조해 작성했다. 
```yaml
---
# 이 플레이북은 인벤토리의 모든 노드에 도커 런타임을 설치한다.
# 주석과 함께 한 줄 한 줄 읽어보자.
#
# 작업 대상을 전체 노드(all)로 설정했다.
# become에 yes를 집어 넣으면 sudo를 이용해 작업들을 수행한다.
# 패키지 매니저를 이용해 패키지를 설치하므로 이 인자를 사용했다.
- hosts: all
  become: yes
  vars:
    # vagrant로 만든 인스턴스의 기본 유저 아이디이다.
    admin_id: vagrant 
    # ubuntu 18.04를 이용해서 bionic을 넣어줬다.
    # 도커 레파지토리를 추가할 때 필요해서 넣어줬다. 
    distro_codename: bionic 

  tasks:
    # 모듈 이름 아래 필요한 인자(arguments)를 넣어서 원하는 작업을
    # 수행하게 한다. 각 모듈 사용법은 앤서블 공식문서에 자세히 나와있다.
    # 이 테스크에선 apt 모듈에 pkg, update_cache 인자를 이용해
    # apt-get update 후에 나열된 패키지를 설치하게 하는 부분이다.
    - name: Update repositories cache and install 
      apt:
        pkg: 
        - apt-transport-https
        - ca-certificates
        - curl
        - software-properties-common
        
        update_cache: yes

    # name에 각 테스크가 어떤 작업을 하는지 적어서 코드만 보고도
    # 이게 어떤 작업인지 알 수 있고, 나중에 터미널에서 어떤 작업들이
    # 잘 수행됐고, 어떤 작업들에서 에러가 났는지 쉽게 알게 한다. 
    - name: Add Docker GPG apt Key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    # repo 인자를 보면 {{ }} 로 위에서 선언한 변수를 감싸서 사용하는 
    # 것을 볼 수 있다. 나중에 다른 디스트로를 사용하는 머신에 적용할 때,
    # 위에서 해당 변수의 값만 바꿔주면 플레이북을 쉽게 재사용할 수 있다. 
    - name: Add Docker Repository
      apt_repository:
        repo: "deb https://download.docker.com/linux/ubuntu {{ distro_codename }} stable"
        state: present

    - name: Install Docker
      apt:
        name: docker-ce
        state: latest
        update_cache: yes

    - name: Append Docker group to the admin user
      user:
        name: "{{ admin_id }}"
        append: yes
        groups: docker
```
(만약 직접 작성하는 것이 귀찮다면, [이 리포](https://github.com/JonghunBok/lab-management/tree/master/sandbox)를 이용해 실험해보도록 하자.)

주석 없이 각 테스크의 `name`만 보고도 어떤 작업들이 수행될지 예상되지 않는가? 이게 IaC가 주는 편리함이다. 위처럼 `playbook.yaml`을 작성하고 나서 `vagrant provision`을 커맨드라인에서 실행하면 다음과 같은 결과를 얻을 것이다.

![`vagrant provision` 실행 결과](https://i.imgur.com/zh4M0a6.png)

위의 과정을 따라했다면, `ok=5`이 아니라 `changed=5`라는 결과를 얻을 것이다. `ok`는 이미 플레이북 작업에서 원하는 상태가 되었다는 뜻이고, `changed`는 머신을 플레이북에서 정의한 상태로 만드려고 변화를 가했다는 뜻이다. 

앤서블 모듈들은 여러 번 같은 작업을 수행해도, 딱 한 번 작업을 수행한 것 같은 효과를 내는데, 이는 모듈들이 *멱등성(idempotence)*[^idempotence]을 고려하고 작성되었기 때문이다. 때문에 마음 놓고 다음의 워크플로우를 반복해도 아무 문제가 없다. 

> "플레이북 편집하고, `vagrant provision`해서 확인하고, 플레이북 편집하고, `vagrant provisoin`해서 확인하고, 플레이북 편집하고, `vagrant provisoin`해서 확인하고, ..."

### 4. 실제 머신에 적용 
검증된 플레이북을 작성해냈다면, 이제 실제 머신에 적용할 차례이다. 적용 머신은 개인 랩탑이 될 수도, EC2 인스턴스가 될 수도, 또 하나의 VM일 수도, on-prem 서버 클러스터에 추가되는 서버일 수도 있다. 어떤 머신이든지 다음 두 작업만 하면 플레이북을 적용할 수 있다.

- ssh server (openssh-server)
- Python

실제 머신에 적용하기 위해선 인벤토리 파일(`inventory`)을 작성하고 다음의 명령어를 실행시키면 된다. 
```bash
# -b : 다른 유저가 되라는 옵션, 기본은 'root'이다.
# -K : 다른 유저가 되기 위해 필요한 비밀번호를 직접 치겠다는 의미이다.
# -k : 노드에 접속하기 위해 필요한 비밀번호를 직접 치겠다는 의미이다.
# 더 편리한 사용을 위해 ansible이 ssh key를 이용해 접속하게 하는 것을 추천한다.
ansible-playbook -b -k -K -i inventory all playbook.yml
```

## 결론 
앤서블을 사용하기 시작할 때, 실제 서버에 설익은 플레이북을 무턱대고 적용하곤 했었다. 그러다 베이그란트를 활용한 워크플로우를 접하게 되었는데, 정말 크게 감탄했다. 이 워크플로우를 이용해 안전하게 자동화하고, 공부할 수 있을 것이다. 많이 부족하지만, 이 글이 자동화 공부를 시작하는 사람들이 개념을 정리하는데 도움이 된다면 좋겠다. 앤서블에 대해 더 공부하고 싶은 사람들에게 *Jeff Geerling*의 [Ansible 101 강의 시리즈](https://www.youtube.com/watch?v=goclfp6a2IQ&list=PL2_OBreMn7FplshFCWYlaN2uS8et9RjNG&index=11)를 강추하며 마무리한다. 

## 자동화해 볼 만한 업무들
- 각 구성원의 유저 아이디 생성
- ntp를 이용해 각 노드의 시스템 타임 동기화 
- 모든 노드에서 공통으로 쓰이는 툴 설치
- 주기적 업데이트/업그레이드
- nvidia에서 제공하는 Anisble Role을 이용해 nvidia docker 설치[^why_nvidia_docker]


[^how_ansible_works]: [How Ansible Works](https://www.ansible.com/overview/how-ansible-works)
[^why_nvidia_docker]: 도커의 기능은 cgroups와 namespaces에 기반한다. 인텔과 AMD가 Linux Cgroups Support for GPUs를 내놓고 있지만, 아직 메인라인 리눅스 커널에 포함되지 않았거나, 도커 런타임이 아직 이 패치를 온전히 활용하고 있지 않은 모양이다. (컴퓨터의 메인 프로세싱 유닛은 CPU라는 것...!).[^cgroups_yet_nogpu] 그래서 따로 nvidia에서 내놓은 nvidia-docker라는 툴킷을 설치해야 컨테이너에서 위에서 설치한 GPU 드라이버를 활용해 컨테이너에서도 GPU를 이용할 수 있다. 
[^cgroups_yet_nogpu]: [Intel & AMD Send Out New Patches For Linux Cgroup Support For GPUs](https://www.phoronix.com/scan.php?page=news_item&px=Linux-Cgroups-GPUs-2019)
[^cncf_ansible]: [Ansible - CNCF](https://landscape.cncf.io/selected=ansible)
[^intro_to_vagrant]: [Introduction to Vagrant](https://www.vagrantup.com/intro/index.html)
[^about_virtualbox]: [About VirtualBox](https://www.virtualbox.org/wiki/VirtualBox)
[^pheonix_server]: [PhoenixServer | martinFowler.com](https://martinfowler.com/bliki/PhoenixServer.html)
[^snowflake_server]: [SnowflakeServer | martinFowler.com](https://martinfowler.com/bliki/SnowflakeServer.html)
[^bcho_manse]: DevOps 관련 퀄리티 높은 우리말 글을 많이 써주셔서 정말로 감사합니다...
[^idempotence]: [[ansible] 멱등성(idempotent) 용어 이해하기](https://knight76.tistory.com/entry/ansible-%EB%A9%B1%EB%93%B1%EC%84%B1idempotent-%EC%9A%A9%EC%96%B4-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0)
