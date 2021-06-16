# HTTPサーバを作る
### ■ server.c
```c
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CLIENT_LIMIT 5
#define MSGSIZE 1024
#define BUFSIZE (MSGSIZE + 1)

int main(int argc, char* argv[])
{
    int serverSock; // server socket FD
    int clientSock; // client socket FD
    struct sockaddr_in serverSockAddr; // server internet socket address
    struct sockaddr_in clientSockAddr; // client internet socket address
    unsigned short serverPort; // server port number
    unsigned int   clientLen; // client internet socket address length
    char recvBuffer[BUFSIZE];
    int recvMsgSize, sendMsgSize;

    if ( argc != 2 ) {
        fprintf(stderr, "argument count mismatch error.\n");
        exit(EXIT_FAILURE);
    }

    if ( (serverPort = (unsigned short) atoi(argv[1])) == 0 ) {
        fprintf(stderr, "invalied port number.\n");
        exit(EXIT_FAILURE);
    }

    if ( (serverSock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0 ) {
        perror("socket() failed.");
        exit(EXIT_FAILURE);
    }

    /* サーバ側のsockaddr_in構造体を初期化 */
    memset(&serverSockAddr, 0, sizeof(serverSockAddr));
    serverSockAddr.sin_family      = AF_INET;           // IPv4を使用
    serverSockAddr.sin_addr.s_addr = htonl(INADDR_ANY); // サーバに割り当てられたすべてのIPアドレスでListen
    serverSockAddr.sin_port        = htons(serverPort); // ポート番号を指定

    /* 作成したソケットにIPアドレスとポート番号をひも付け */
    /* sockaddr_in構造体をsockaddr構造体のポインタにキャストされていることに注意 */
    /* ポインタ型のキャストについて
     * アドレスに保存されるデータをどの型で見るか!!!
    */
    if ( bind(serverSock, (struct sockaddr *) &serverSockAddr, sizeof(serverSockAddr)) < 0 ) {
        perror("bind() failed.");
        exit(EXIT_FAILURE);
    }

    /* クライアントからの接続を受け付ける状態へ */
    if ( listen(serverSock, CLIENT_LIMIT) < 0 ) {
        perror("listen() failed.");
        exit(EXIT_FAILURE);
    }

    while(1) {
        clientLen = sizeof(clientSockAddr);
        /* キューからESTABLISHED状態のソケット構造体を取り出し、それにFDを割り当て、ユーザプロセスに返す */
        if ( (clientSock = accept(serverSock, (struct sockaddr *) &clientSockAddr, &clientSock)) < 0 ) {
            perror("accept() failed.");
            exit(EXIT_FAILURE);
        }

        printf("connected from %s.\n", inet_ntoa(clientSockAddr.sin_addr));

        while(1) {
            /* コネクションが切れたらループを抜けて再びacceptする */
            if ( (recvMsgSize = recv(clientSock, recvBuffer, BUFSIZE, 0)) < 0 ) {
                perror("recv() failed.");
                exit(EXIT_FAILURE);
            } else if ( recvMsgSize == 0 ) {
                fprintf(stderr, "connection closed by foreign host.\n");
                break;
            }

            /* コネクションが切れたらループを抜けて再びacceptする */
            if ( (sendMsgSize = send(clientSock, recvBuffer, recvMsgSize, 0)) < 0 ) {
                perror("send() failed.");
                exit(EXIT_FAILURE);
            } else if ( sendMsgSize == 0 ) {
                fprintf(stderr, "connection closed by foreign host.\n");
                break;
            }
        }
        close(clientSock);
    }
    close(serverSock);
    return EXIT_SUCCESS;
}
```
### ■ client
mikan
```c
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MSGSIZE 32
#define MAX_MSGSIZE 1024
#define BUFSIZE (MSGSIZE + 1)

int main(int argc, char* argv[])
{
    int sock; // local socket FD
    struct sockaddr_in serverSockAddr;
    unsigned short serverPort;
    char recvBuffer[BUFSIZE]; // receive buffer
    char sendBuffer[BUFSIZE]; // send buffer

    if ( argc != 3 ) {
        fprintf(stderr, "argument count mismatch error.\n");
        exit(EXIT_FAILURE);
    }

    if ( (serverPort = (unsigned short) atoi(argv[2])) == 0 ) {
        fprintf(stderr, "Invalied port number.\n");
        exit(EXIT_FAILURE);
    }

    if ( inet_aton(argv[1], &serverSockAddr.sin_addr) == 0 ) {
        fprintf(stderr, "Invalied IP Address.\n");
        exit(EXIT_FAILURE);
    }

    if ( (sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0 ) {
        perror("socket() failed.\n");
        exit(EXIT_FAILURE);
    }

    memset(&serverSockAddr, 0, sizeof(serverSockAddr));
    serverSockAddr.sin_family = AF_INET;
    serverSockAddr.sin_port   = htons(serverPort);

    if ( connect(sock, (struct sockaddr*) &serverSockAddr, sizeof(serverSockAddr)) < 0 ) {
        perror("connect() failed.");
        exit(EXIT_FAILURE);
    }

    printf("connect to %s\n", inet_ntoa(serverSockAddr.sin_addr));

    while (1) {
        printf("please enter the charcters: ");
        if ( fgets(sendBuffer, BUFSIZE, stdin) == NULL ) {
            fprintf(stderr, "Invalid input string.\n");
            exit(EXIT_FAILURE);
        }

        /* strlen -> BUFSIZEでよくね? */
        /* Ans. fgetsで追加されたNULL文字を除外するため(NULL文字を含めないので) */
        if ( send(sock, sendBuffer, strlen(sendBuffer), 0) <= 0 ) {
            perror("send() failed.");
            exit(EXIT_FAILURE);
        }

        int byteRcvd  = 0;
        int byteIndex = 0;
        while (byteIndex < MSGSIZE) {
            /* 1byteずつrecvBufferからデータを受け取る */
            byteRcvd  = recv(sock, &recvBuffer[byteIndex], 1, 0);
            if ( byteRcvd > 0 ) {
                if ( recvBuffer[byteIndex] == '\n' ) {
                    recvBuffer[byteIndex] = '\0';
                    if ( strcmp(recvBuffer, "quit") == 0 ) {
                        close(sock);
                        return EXIT_SUCCESS;
                    } else {
                        break;
                    }
                }
                byteIndex += byteRcvd;
            } else if ( byteRcvd == 0 ) {
                perror("ERR_EMPTY_RESPONSE");
                exit(EXIT_FAILURE);
            } else {
                perror("recv() failed.");
                exit(EXIT_FAILURE);
            }
        }
        printf("server return: %s\n", recvBuffer);
    }
    return EXIT_SUCCESS;
}
```
