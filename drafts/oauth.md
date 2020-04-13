# OAuth 2.0 이해하기

## 용어들
- Resource Owner
- Resource Server
- Client
- Client ID
- Client Secret

## 절차
1. 클라이언트가 리소스 서버에 등록을 한다.
  "당신네 서비스를 이용하고 싶소"
2. 리소스 서버가 클라이언트에게 "Client ID"와 "Client Secret"을 발급해준다.
3. 클라이언트가 리소스 오너에게 리소스 서버에서 어떤 리소스를 쓸 수 있게끔 허락해달라고 요청
4. 리소스 오너가 리소스 서버에 연결되어 허락
5. 리소스 서버가 클라이언트에 해당 리소스에 접근을 허가하는 코드 발급 
6. 클라이언트가 "Client ID", "Client Secret", 과 코드를 리소스 서버에 보내어 알맞은 요청이라는 걸 증명.
7. 리소스 서버가 클라이언트에 "Access Token"을 발급
8. 클라이언트가 "Access Token"을 이용해 리소스 서버로부터 리소스 획득 
