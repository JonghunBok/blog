---
title: '번역; ML 프로덕트를 만드는데 필요한 것들에 대한 놀라운 진실'
tags:
  - translation
  - ML Product
categories:
  - translation
date: 2020-02-01 18:03:45
intro: 
  - 블로그 글을 읽을 때 계산을 게으르게 한다는 표현이 심심치않게 보인다.
  - 그 표현에 대한 개념을 잡기 위해 영문 위키피디아의 개요를 번역해보았다.
  - 내용 이해에 불필요한 부분은 과감히 생략하였다.
refs:
---
내가 대학에 있을 적에, 근처에 아이스크림집이 개장해서, 몇 친구들과 함께 시도해보러 갔다. 
우리가 들어간 상점은 크게 특별한 게 없어 보였다. 그들은 일반적인 맛들; 민트, 초콜렛 등등을 팔고 있었다. 그런데 카운터의 끝쪽에 "브로콜리 서프라이즈"라는 맛의 아이스크림이 있었다. 천성적으로 호기심이 많은 나는 이걸 맛봐야만 했다. 카운터 뒤의 점원에게 샘플을 요청했다. 그 아이스크림은 하얗고 조그만 초록 알갱이들이 박힌 하얀 아이스크림이었고, 달콤하고, 부드럽고, 풍부한 맛을 가지고 있었다. 브로콜리 맛이 없어 나는 혼란스러웠다. "어떤 점이 서프라이즈인거죠?"라고 점원에게 물었더니, 그녀는 "거기엔 브로콜리가 없어요."라고 미소와 함께 대답했다. 

> When I was in college, an ice cream shop opened nearby, and a few friends and I went to check it out. We walked in, and it looked completely normal — they had all the usual flavors like mint, chocolate, and the like. However, at the end of the counter, they had this flavor called “The Broccoli Surprise”. A naturally curious individual, I had to try it. I asked the attendant behind the counter for a sample. It was white with little green specks, and it tasted sweet, creamy, and rich. I was confused — there was no broccoli flavor in here. So I asked, “what’s the surprise?” “There’s no broccoli,” she replied with a smile.

머신러닝(ML)도 서프라이즈를 갖고 있다. 기관 안에서의 ML 배포 에 대한 가장 큰 오해는 무엇이 어렵고 가치 있는지를 이해할 때 발생한다. 

> Machine learning (ML) has a surprise, too. One of the biggest misconceptions about ML deployment within organizations is comprehending the difficulty and the value.


ML을 비즈니스 워크플로우에 통합하는 작업은 5개의 세부 작업으로 나눌 수 있다.
> Integrating ML into your business workflows can be broken down into five activities:

**KPI 결정** - KPI(Key Performance Indicators)는 우리가 향상시키려 하는 대상을 측정하고 그것에 대해 토론할 수 있게 도와준다. 일반적인 KPI로는 *고객 유지*, *제조 수율*, *직원 이직* 등이 있다. KPI는 성능 좋은 모델을 만들기 위한 최적화 작업을 이끌기 때문에, KPI 결정은 머신 러닝에 매우 중요한 과정이다.  

> Defining KPIs — Key Performance Indicators allow us to measure and discuss what we are trying to improve. Common KPIs include customer retention, manufacturing yield, or employee turnover. Setting KPIs is a critical step in Machine Learning since they ultimately drive optimization along the way to a performant model.

**데이터 수집** - ML 알고리즘을 학습시키기 위한 데이터를 모으는 작업. 그렇다, 만약 데이터가 부족하면 다른 사람들이 만든 ML 모델을 사용해도 된다. 하지만 그런 비즈니스 고려사항은 다른 SaaS 제품들과 비슷하므로 논의하지 않겠다.

> Collecting Data — Collecting the data that will be used to train your ML algorithms. Yes, you could use ML models others have produced if you lack data. However those business considerations are similar to other SaaS offerings, so let’s leave them out of scope here.

**인프라스트럭쳐** - ML 인프라는 다양한 소프트웨어를 포함한다: 데이터 관리, 주석 작성 도구, 모델 학습, 모델 테스팅 환경 등. 이런 인프라는 사전 투자이지만, 모델과 데이터 셋을 반복해 향상시키는 것을 훨씬 효율적이게 해준다.

> Infrastructure — ML infrastructure includes various pieces of software: data management, annotation tools, model training, and testing environments. This infrastructure is an upfront investment, but makes iterating and improving the model and data set much more efficient.

**ML 알고리즘 최적화** - 여기서 우리는 주어진 데이터셋과 문제에 기반한 필요 모델, 학습 데이터의 필요량, 신경망의 레이어, 하이퍼 파라미터 튜닝  기반한 모델 선택처럼 다양한 요소를 고려한다. 정말 많은 선택지가 있다. 

> Optimizing ML Algorithm — Here we consider factors like which model to use based on a given data set/problem, the amount of necessary training data, the layers in your neural net, and hyperparameter tuning. There are a plethora of choices.


**통합** - 진공에서 ML 모델이 작동하게 하는 것 또한 큰 성취지만, 실무 워크플로우에 통합될 때서야 실재적인 비즈니스 효과를 창출할 수 있다. 통합은 유저와 컴퓨터 사이에 정보가 원활히 오가게 하는 파이프와 구조를 만드는 과정이다.

> Integration — Getting an ML model working in a vacuum is a great achievement, but it is not until the model is integrated with a real workflow that it starts to create a tangible business impact. Integration is the process of building pipes and structure which seamlessly pass information and data between users and computers.


머신 러닝에 관심이 있는 기업과의 많은 대화를 통해, 머신러닝 알고리즘 최적화과 많은 노력이 들며 결실을 가져다주는 과정이라는 인식이 지배적인 걸 알 수 있었다.

> Based on many conversations with companies interested in deploying machine learning, there is a high perceived effort required in, and pay off from, optimizing a machine learning algorithm.

이 현상에 대한 가능한 이유들은:
- 대부분의 실무자들에게 ML 모델 최적화는 가장 큰 "블랙박스"이다. 그래서 이 부분이 실제보다 더 복잡하고 시간이 많이 들 거라고 생각하기 쉽다.
- *가용성 휴리스틱* -  ML 알고리즘과 최적화가 문헌과 매체에서 더 얘기되다 보니, 사람들은 이 부분이 실제 구현 프로세스에서 갖는 것보다 더 큰 역할을 맡는다고 생각하게 된다. 

> There are a few possible reasons for this:
> - For most practitioners, optimizing ML models is the biggest “unknown” in the stack, so it’s easy to imagine it being more complicated and time-consuming than it really is.
> - Availability Heuristic — since ML algorithms and optimization are talked about more in literature and media, it is common for people to assume that they play larger roles than they do in the actual implementation process.


## **The Surprise**
구글에서 ML 시스템을 만들고 스케일링 해본 경험이 많은 실무자들과 대화하면, 매우 다른 이야기를 듣게 된다. 이 대화들에 따르면, ML 알고리즘 최적화는 비교적 매우 적은 노력이 들지만, **데이터 수집과 인프라 구축, 통합**이 훨씬 수고스럽다. 기대와 현실의 차이는 지대했다.

> When I talk to practitioners that have had a lot of experience building and scaling these ML systems inside Google, I hear a very different story. Based on these conversations, optimizing an ML algorithm takes much less relative effort, but collecting data, building infrastructure, and integration each take much more work. The differences between expectations and reality are profound.

**KPI 결정** - 한 번 *데이터 주도 시스템*을 배포하면, 지속적인 데이터 피드백의 흐름이 있기 때문에 KPI를 고르는데 들어가는 시간과 기관 자원이 줄어든다. 이는 프록시 KPI의 필요를 제거한다. 좋은 ML은 좋은 데이터에 입각하기 때문에, 우리는 훌륭한 파이프라인들을 가지고 있어야 한다.

> Defining KPIs — once we deploy data-driven systems, we spend less time and organizational resources selecting KPIs since there are constant streams of data feedback. This obviates the need for proxy KPIs. Since good ML is predicated on good data, we must have a great collection pipeline already in place.

**데이터 수집** - ML 프로젝트를 추진할 때 데이터 수집은 항상 과소평가된다. 데이터 콜렉션을 만들고 가공하는 전략을 결정할 때 필요한 고려 사항들은 [저번 포스트](https://medium.com/thelaunchpad/where-does-data-come-from-6115ed2a3a3b)에서 설명했다.

> Collecting Data — Collecting data is almost always an underestimated component of spinning up an ML project. Some factors to consider when building a data collection and processing strategy are described in a previous post.



**인프라스트럭쳐** - 인프라 건설은 "ML 업무"와 대조되게 거의 소프트웨어 엔지니어링이고, 대부분의 프로젝트에서 가장 시간이 많이 드는 부분이다.

> Infrastructure — Infrastructure building, which is mostly a software engineering task as opposed to an “ML task,” is one of the most time-consuming parts of most projects.


**ML 알고리즘 최적화** - ML 모델을 학습시키고 최적화하는 건 거의 언제나 기대받는 것보다 적은 시간과 노력이 든다. 여기엔 두가지 이유가 있는데, 첫째로 성능은 어떤 데이터를 갖고 있냐에 크게 좌우된다. 알고리즘을 손보는 건 효과가 있긴 하지만 데이터 정리에 비해 그 효과가 미미하다. 둘째로 AutoML과 같은 ML 알고리즘 최적화툴이 데이터, 분류가 됐든 안됐든,에 기반해 모델을 학습시키고 최적화하는 걸 훨씬 빠르게 해준다.

> Optimizing ML Algorithm — The task of training and optimizing ML models almost always takes less time and effort than anticipated for two reasons. First, performance is a strong function of what data you possess. Tweaking algorithms yields benefits, however, pales in comparison to cleaning up your data. Second, tools for optimizing ML algorithms (like AutoML) make it much easier and faster to train and optimize models based on labeled or unlabeled data.


**통합** - 통합 또한 ML 프로젝트에서 과소평가되는 부분이다. 에러와 예외 처리, 리던던시, 정적인 제품에서 일련의 과정이 지속적으로 반복되는 제품으로의 전환 등은 소프트웨어, 제품, 엔지니어링 분야에 난점을 가져온다. 한 번 당신의 학습 데이터에 숨겨져 있는 기술적 빚을 생각해보아라!

> Integration — integration is another underestimated part of the ML deployment process. Error and exception handling, redundancies, and the challenge of moving from a static product to one of continuous iterations presents a host of software, product, and engineering challenges. Just think of all the technical debt hidden inside of your training data!

__

ML은 사실 두 개의 서프라이즈를 갖고 있다.

첫째, 많은 회사가 ML 구현의 어떤 과정이 힘들 것인지 잘못 알고 있다. 도구와 기술적 진보가 소프트웨어 인프라를 통해 ML 최적화의 양상을 정말 빠르게 바꾸고 있어서 브루트 포스 데이터 수집과 관리가 따라오기 힘들 정도이다. 마치 브로콜리 아이스크림처럼, 종단간 ML 시스템에 보통 ML은 그렇게 많이 들어있지 않다.

둘째, 당신의 고객에 대해 생각해보고, 데이터를 수집하고 해석해서 행동의 근거로 사용하기 위해 인프라를 구축하는  ML 구현 여정은, 결국 ML 구현 여부를 떠나 귀중하다. 모든 문제는 아니지만 많은 문제가  ML 기반 해결책이 있을 수 있고, 그렇지 않은 문제들에 대해서도 이 여정에서 얻을 수 있는 게 있기 때문이다.















[원본](https://medium.com/thelaunchpad/the-ml-surprise-f54706361a6c)